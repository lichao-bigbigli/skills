# 分步流水线参考（build_farewell_video.sh 不可用时的手工流程）

以下命令模板基于 v7 交付参数（1920x1080，30fps）。画幅不同时替换对应尺寸；所有字幕 PNG 先用 `make_overlays.py --out DIR --w W --h H` 生成。

## 0. 素材变量约定

| 变量 | 内容 | 典型来源 |
|------|------|----------|
| V_TEACHER_A/B/C/D | 老师出镜口播 ×4 | 直播录制/自拍 |
| V_SCREEN_QUEUE / V_SCREEN_STL | 课件录屏 ×2 | 直播回放录屏 |
| V_COMMENTS | 学生评价留言滚动录屏 | 评价系统页面录制 |
| PROLOGUE_IMG | 2x2 AI 插画（底部含 ~8.5% 高字幕条） | 文生图 |
| RABBIT_IMG | 第一幕背景图（递推/兔子数列课件截图） | 课件截图 |

## 1. 素材切四格（序章插画）

```python
# split_prologue.py <img> <outdir>
from PIL import Image
img = Image.open(img_path); W,H = img.size; pw = W//2
cells = {
 "p1_cursor": (6,6,pw-6,404), "p2_monkey": (pw+6,6,W-6,404),
 "p3_hand": (6,452,pw-6,800), "p4_glow": (pw+6,452,W-6,800)}
```

底行 top 要多裁（~452 而非 410）以去除上格渗色；底行 bottom 裁到 800 去黑线。

## 2. 序章动效（Ken Burns + 交叉溶解 + 亮度爬升）

```bash
# P1 光标缓推（2.7s 后开始溶解）
ffmpeg -y -loop 1 -t 3.2 -framerate 30 -i p1_cursor.png -vf \
"scale=2300:-2,zoompan=z='min(zoom+0.0006,1.12)':d=1:x='iw/2-(iw/zoom/2)':y='ih*0.45-(ih/zoom/2)':s=1920x1080:fps=30,fade=t=in:st=0:d=0.8,format=yuv420p" ...
# P2 猴子轻推 2.6s | P3 按回车加速推 (zoom 0.0012→1.18, 焦点 0.62,0.55) 2.2s
# P4 亮起: eq=brightness='min(0.12,t*0.05)' 2.8s
# xfade 链: offsets 2.7 / 4.8 / 6.6, 尾部 fade=t=out:st=8.7:d=0.6
```

序章字幕三段显隐：sub1 0.3–2.4s、sub2 4.9–6.4s、sub3 7–8.6s（各 0.4–0.6s 渐变，format=rgba 先行）。

## 3. 第一幕 递推（5s，无原声补静音轨）

背景图 zoompan + act1.png overlay 渐显，或纯黑底。**必须补 anullsrc 静音轨**供 concat。

## 4. 第二幕 课件快剪（5×3s，保留原声）

```bash
ffmpeg -y -ss <点> -t 3 -i "$SRC/$V.mp4" -i "$OV/act2_x.png" -filter_complex \
"[0:v]scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,fps=30[bv];[bv][1:v]overlay=0:0,format=yuv420p[v2]" \
-map "[v2]" -map 0:a -t 3 -c:v libx264 -preset veryfast -crf 21 -c:a aac -b:a 128k out.mp4
```

切点（queue 录屏）：3 / 20 / 44s；（stl 录屏）：8 / 44s。切点尽量落在句间。

## 5. 第三幕 留言（9s，0.5→1.3 倍慢放 + 双层字幕交替）

```bash
ffmpeg -y -ss 8 -t 9 -i comments.mp4 -loop 1 -t 9 -i act3_sub1.png -loop 1 -t 9 -i act3_sub2.png -filter_complex \
"[0:v]setpts=1.3*PTS,scale=2246:-2,zoompan=z='min(zoom+0.0003,1.08)':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1920x1080:fps=30[bv]; \
[1:v]format=rgba,fade=t=out:st=4.2:d=0.8:alpha=1[s1]; \
[2:v]format=rgba,fade=t=in:st=4.5:d=1:alpha=1[s2]; \
[bv][s1]overlay[b1];[b1][s2]overlay,format=yuv420p[v2]"
```

留言文案必须摘自素材真实内容（抽全分辨率帧逐条读），带原时间戳。

## 6. 第四幕 老师出镜（6+5+6+7s，锐化+暗角，保留原声）

```bash
filter_complex="[0:v]scale=1930:1088:force_original_aspect_ratio=increase,crop=1920:1080,unsharp=5:5:0.8:5:5:0.0,vignette=PI/5,fps=30[bv];[bv][1:v]overlay=0:0,format=yuv420p[v2]"
# 切点: A 0-6s, B 2-7s(仅5s——素材尾部有卡顿帧，宁短勿卡), C 1-7s, D 5-12s
```

## 7. 尾声三卡（黑底，总 21s）

- act5: 12s，字幕 fade in 0.5s/1.2s，fade out 10.8s/1.2s
- credits: 4.5s，fade in 0.6s，fade out 3.5s/1s
- next（预告）: 4.5s，同 credits
- 每张卡补静音轨。

## 8. 拼接 + 配乐

```bash
# concat 列表：序章, act1, act2_a..e, act3, act4_a..d, act5, credits, next
ffmpeg -y -f concat -safe 0 -i list.txt -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 128k base.mp4

# BGM: sidechain ducking + 首尾淡入淡出 + loudnorm
ffmpeg -y -i base.mp4 -i bgm.mp3 -filter_complex \
"[1:a]atrim=0:$DUR,asetpts=PTS-STARTPTS,afade=t=in:st=0:d=1.5,afade=t=out:st=$FADE:d=4[bgm0]; \
[bgm0]volume=0.55[bgm];[0:a]asplit[voice][sc];[voice]volume=1.0[v]; \
[bgm][sc]sidechaincompress=threshold=0.03:ratio=8:attack=80:release=500:makeup=1[ducked]; \
[v][ducked]amix=inputs=2:duration=first:dropout_transition=2,loudnorm=I=-16:TP=-1.5:LRA=11[a]" \
-map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k -t $DUR final.mp4
```

## 9. 验收

抽帧位置：序章每格、各幕中点、每个转场缝 ±0.5s、片尾三卡。检查：黑帧、双层字幕重叠、字幕出画、衔接跳变、音轨时长 == 视频时长。

## 10. 画幅变体

- 4:3 → 1440x1080：所有 scale/crop 目标替换；字卡 overlay PNG 用 `--w 1440` 重生成；老师出镜素材≈原生 4:3 零裁切最优。
- 其他竖版/方形同理：改 make_overlays.py 的 W/H（字号随 H 缩放，位置用 H 比例），切片 scale/crop 目标改即可。

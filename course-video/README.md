# course-farewell-video — 班级结课煽情视频快速上手

> 一条流水线把课堂素材（老师出镜 / 课件录屏 / 学生留言）自动剪成 1 分多钟的结课煽情成片。
> 已在 ZCode（模型 GLM）实测交付：猿编程 A3 班《数据结构与高级算法》结课视频（v7 结构，83 秒）。

## 这条流水线产出什么

```
序章(9s)       AI 插画四格：光标闪烁 → 回车按下 → 屏幕亮起映亮眼眸
第一幕(5s)     递推开场：f[i] = f[i-1] + f[i-2]
第二幕(15s)    课件快剪 5×3s（保留老师原声）
第三幕(9s)     学生真实留言慢放（催泪点）
第四幕(24s)    老师出镜寄语 ×4 段（保留原声，锐化+暗角）
第五幕(12s)    DP 尾声：dp[n] = best(dp[all the days we had]);
落款卡(4.5s)   课程名 · 年份 · 品牌
预告卡(4.5s)   「冲刺班 · 算法设计与程序优化 等 你」
─────────────────────────────────────────────
成片约 83 秒，含 BGM 自动压低混音（人声优先）
```

## 快速使用（三步）

### 第 1 步：准备素材

把素材放进一个目录，默认按以下文件名识别（文件名不同用环境变量覆盖，见下）：

| 默认文件名 | 内容 |
|-----------|------|
| `2026-10-28 11-15-01.mp4` | 老师出镜 A（开场寄语） |
| `2026-10-28 11-16-04.mp4` | 老师出镜 B |
| `2026-10-28 11-19-09.mp4` | 老师出镜 C |
| `2026-10-28 11-17-25.mp4` | 老师出镜 D（结尾核心） |
| `2026-10-28 11-20-46.mp4` | 课件录屏 1（如队列章节） |
| `2026-10-28 11-23-48.mp4` | 课件录屏 2（如 STL/栈） |
| `2026-10-28 11-28-50.mp4` | 学生评价留言滚动录屏 |

可选：`PROLOGUE_IMG`（2×2 AI 插画，文生图生成序章背景）、`RABBIT_IMG`（第一幕课件截图）。

BGM：一首 mp3（如《起风了》《那些年》）。

### 第 2 步：让 ZCode 生成脚本并确认

对 ZCode 说：

> 帮我用 `~/Desktop/视频素材/xxx` 这些素材做一个结课视频

模型会自动触发本 skill：先用 ffprobe/抽帧盘点素材 → 产出脚本文档（分镜+字幕文案）给你确认。**检查两处**：老师出镜段的字幕是代写文案（可提供老师原话替换）；第三幕留言必须来自素材真实内容。

### 第 3 步：一键合成

确认脚本后，模型会执行（也可手动运行）：

```zsh
# 16:9
~/.agents/skills/course-farewell-video/scripts/build_farewell_video.sh \
  <素材目录> <输出目录> <BGM.mp3>

# 4:3
~/.agents/skills/course-farewell-video/scripts/build_farewell_video.sh \
  <素材目录> <输出目录> <BGM.mp3> 1440 1080
```

文件名不同时的覆盖方式：

```zsh
V_TEACHER_A="老师A.mp4" V_TEACHER_B="老师B.mp4" \
V_TEACHER_C="老师C.mp4" V_TEACHER_D="老师D.mp4" \
V_SCREEN_QUEUE="课件1.mp4" V_SCREEN_STL="课件2.mp4" \
V_COMMENTS="留言.mp4" \
PROLOGUE_IMG="插画.jpeg" RABBIT_IMG="兔子数列.png" \
~/.agents/skills/course-farewell-video/scripts/build_farewell_video.sh \
  ~/Desktop/素材 ~/Desktop/输出 ~/Desktop/起风了.mp3
```

输出：`<输出目录>/结课视频_成片.mp4`，中间产物在 `<输出目录>/build/`（可单段重剪）。

## 环境要求

| 依赖 | 检查命令 | 说明 |
|------|---------|------|
| ffmpeg | `ffmpeg -version` | homebrew ffmpeg 9 实测通过；**无 drawtext 滤镜也能跑**（字幕走 Pillow） |
| Pillow | `python3 -c "import PIL"` | 字幕渲染 |
| 中文字体 | `ls ~/Library/Fonts/PingFang.ttc` | 默认字体，可用 `--font` 换 |

## 字幕/文案定制

所有字幕集中在 `scripts/make_overlays.py` 里，改文案后重新跑一遍再合成即可：

```zsh
python3 ~/.agents/skills/course-farewell-video/scripts/make_overlays.py \
  --out <输出目录>/build/overlays --w 1920 --h 1080
```

- 字幕风格已固化：加粗；白底画面黑字/深蓝字+白衬底；深底画面白字黑描边；代码蓝色
- 第三幕留言 = 评价系统真实内容 + 原时间戳（蓝色），换成自己班级的留言时直接改 `rows` 列表
- 落款卡/预告卡的课程名、品牌名在同文件的 `credits.png` / `next.png` 定义处

## 常见问题

- **某段素材尾部卡顿** → 重跑时把该段时长裁短（B 段默认 5s 就是为此）
- **视频结尾没声音** → 检查合成最后一步 `-t 总时长` 是否覆盖全片
- **想换画幅**（竖版 9:16 等）→ `make_overlays.py --w 1080 --h 1920` + 合成脚本对应尺寸参数
- **skill 不触发** → 确认目录在 `~/.agents/skills/course-farewell-video/`，或显式 `/course-farewell-video`

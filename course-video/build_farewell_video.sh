#!/usr/bin/env zsh
# build_farewell_video.sh — 班级结课煽情视频一键合成（v7 结构：序章+五幕+落款+预告）
# 用法: build_farewell_video.sh <素材目录> <输出目录> <BGM路径> [宽] [高]
# 默认 1920x1080 (16:9)；传 1440 1080 即为 4:3
set -e

SRC="${1:?用法: build_farewell_video.sh <素材目录> <输出目录> <BGM路径> [宽] [高]}"
OUT="${2:?缺少输出目录}"
BGM="${3:?缺少BGM路径}"
FW="${4:-1920}"
FH="${5:-1080}"

WORK="$OUT/build"
mkdir -p "$WORK"
SCRIPT_DIR="${0:A:h}"
FONT="$HOME/Library/Fonts/PingFang.ttc"
# 可通过环境变量覆盖素材文件名（默认按时间戳命名）
V_TEACHER_A="${V_TEACHER_A:-2026-10-28 11-15-01}"
V_TEACHER_B="${V_TEACHER_B:-2026-10-28 11-16-04}"
V_TEACHER_C="${V_TEACHER_C:-2026-10-28 11-19-09}"
V_TEACHER_D="${V_TEACHER_D:-2026-10-28 11-17-25}"
V_SCREEN_QUEUE="${V_SCREEN_QUEUE:-2026-10-28 11-20-46}"
V_SCREEN_STL="${V_SCREEN_STL:-2026-10-28 11-23-48}"
V_COMMENTS="${V_COMMENTS:-2026-10-28 11-28-50}"

echo "== 1/6 生成字幕 overlay PNG（Pillow，加粗+描边阴影） =="
python3 "$SCRIPT_DIR/make_overlays.py" --out "$WORK/overlays" --w "$FW" --h "$FH" --font "$FONT" || {
  # 旧版 make_overlays.py 不支持参数时的兜底：提示手工检查
  echo "overlay 生成失败，检查 make_overlays.py 路径参数"; exit 1; }
OV="$WORK/overlays"

ENC="-c:v libx264 -preset veryfast -crf 21 -c:a aac -b:a 128k"

echo "== 2/6 序章（插画 Ken Burns + xfade + 字幕） =="
# 需要用户提供 2x2 插画（环境变量 PROLOGUE_IMG），先切四格再动效
if [ -n "$PROLOGUE_IMG" ]; then
  python3 - "$PROLOGUE_IMG" "$WORK" << 'PY'
import sys
from PIL import Image
img = Image.open(sys.argv[1]); W,H = img.size; pw=W//2
cells = {"p1_cursor":(6,6,pw-6,404),"p2_monkey":(pw+6,6,W-6,404),"p3_hand":(6,452,pw-6,800),"p4_glow":(pw+6,452,W-6,800)}
for n,b in cells.items(): img.crop(b).save(f"{sys.argv[2]}/{n}.png")
PY
  # 动效参数按画幅宽缩放
  ffmpeg -y -loglevel error -loop 1 -t 3.2 -framerate 30 -i "$WORK/p1_cursor.png" -vf "scale=$((FW+380)):-2,zoompan=z='min(zoom+0.0006,1.12)':d=1:x='iw/2-(iw/zoom/2)':y='ih*0.45-(ih/zoom/2)':s=${FW}x${FH}:fps=30,fade=t=in:st=0:d=0.8,format=yuv420p" -an $ENC "$WORK/p1.mp4"
  ffmpeg -y -loglevel error -loop 1 -t 2.6 -framerate 30 -i "$WORK/p2_monkey.png" -vf "scale=$((FW+330)):-2,zoompan=z='min(zoom+0.0005,1.08)':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${FW}x${FH}:fps=30,format=yuv420p" -an $ENC "$WORK/p2.mp4"
  ffmpeg -y -loglevel error -loop 1 -t 2.2 -framerate 30 -i "$WORK/p3_hand.png" -vf "scale=$((FW+430)):-2,zoompan=z='min(zoom+0.0012,1.18)':d=1:x='iw*0.62-(iw/zoom/2)':y='ih*0.55-(ih/zoom/2)':s=${FW}x${FH}:fps=30,format=yuv420p" -an $ENC "$WORK/p3.mp4"
  ffmpeg -y -loglevel error -loop 1 -t 2.8 -framerate 30 -i "$WORK/p4_glow.png" -vf "scale=$((FW+330)):-2,zoompan=z='min(zoom+0.0005,1.08)':d=1:x='iw*0.35-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${FW}x${FH}:fps=30,eq=brightness='min(0.12,t*0.05)':saturation=1.05,format=yuv420p" -an $ENC "$WORK/p4.mp4"
  ffmpeg -y -loglevel error -i "$WORK/p1.mp4" -i "$WORK/p2.mp4" -i "$WORK/p3.mp4" -i "$WORK/p4.mp4" -filter_complex "[0:v][1:v]xfade=transition=fade:duration=0.5:offset=2.7[x1];[x1][2:v]xfade=transition=fade:duration=0.5:offset=4.8[x2];[x2][3:v]xfade=transition=fade:duration=0.4:offset=6.6[x3];[x3]fade=t=out:st=8.7:d=0.6,format=yuv420p[v]" -map "[v]" -an $ENC "$WORK/prologue.mp4"
  ffmpeg -y -loglevel error -i "$WORK/prologue.mp4" -loop 1 -t 9.4 -framerate 30 -i "$OV/pre_sub1.png" -loop 1 -t 9.4 -framerate 30 -i "$OV/pre_sub2.png" -loop 1 -t 9.4 -framerate 30 -i "$OV/pre_sub3.png" -filter_complex "[1:v]format=rgba,fade=t=in:st=0.3:d=0.5:alpha=1,fade=t=out:st=2.4:d=0.4:alpha=1[s1];[2:v]format=rgba,fade=t=in:st=4.9:d=0.4:alpha=1,fade=t=out:st=6.4:d=0.4:alpha=1[s2];[3:v]format=rgba,fade=t=in:st=7:d=0.5:alpha=1,fade=t=out:st=8.6:d=0.6:alpha=1[s3];[0:v][s1]overlay=0:0[b1];[b1][s2]overlay=0:0[b2];[b2][s3]overlay=0:0,format=yuv420p[v]" -map "[v]" -an $ENC "$WORK/prologue_sub.mp4"
  ffmpeg -y -loglevel error -i "$WORK/prologue_sub.mp4" -f lavfi -i anullsrc=r=44100:cl=stereo -map 0:v -map 1:a -c:v copy -c:a aac -b:a 128k -t 9.4 "$WORK/seg_prologue.mp4"
  PROLOGUE_SEG="$WORK/seg_prologue.mp4"
fi

echo "== 3/6 五幕正片 =="
# 第一幕 兔子数列（PROLOGUE_IMG 可选，缺省直接黑屏字幕）
if [ -n "$RABBIT_IMG" ]; then
  ffmpeg -y -loglevel error -loop 1 -t 5 -framerate 30 -i "$RABBIT_IMG" -loop 1 -t 5 -framerate 30 -i "$OV/act1.png" -filter_complex "[0:v]scale=${FW}:${FH}:force_original_aspect_ratio=increase,crop=${FW}:${FH},zoompan=z='min(zoom+0.0008,1.1)':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${FW}x${FH}:fps=30[bg];[1:v]scale=${FW}:${FH}[ov];[bg][ov]overlay=0:0,fade=t=in:st=0:d=0.6,format=yuv420p[v2]" -map "[v2]" -an -t 5 $ENC "$WORK/seg_act1.mp4"
else
  ffmpeg -y -loglevel error -f lavfi -i color=c=black:s=${FW}x${FH}:r=30:d=5 -loop 1 -t 5 -framerate 30 -i "$OV/act1.png" -filter_complex "[1:v]format=rgba,fade=t=in:st=1:d=1.5:alpha=1[ov];[0:v][ov]overlay=0:0,format=yuv420p[v2]" -map "[v2]" -an -t 5 $ENC "$WORK/seg_act1.mp4"
fi
ffmpeg -y -loglevel error -i "$WORK/seg_act1.mp4" -f lavfi -i anullsrc=r=44100:cl=stereo -map 0:v -map 1:a -c:v copy -c:a aac -b:a 128k -t 5 "$WORK/seg_act1a.mp4" && mv "$WORK/seg_act1a.mp4" "$WORK/seg_act1.mp4"

# 第二幕 课件快剪 5x3s（保留原声）
cut2() { ffmpeg -y -loglevel error -ss "$2" -t 3 -i "$SRC/$1.mp4" -i "$OV/$3.png" -filter_complex "[0:v]scale=${FW}:${FH}:force_original_aspect_ratio=increase,crop=${FW}:${FH},fps=30[bv];[bv][1:v]overlay=0:0,format=yuv420p[v2]" -map "[v2]" -map 0:a -t 3 $ENC "$WORK/seg_act2_$4.mp4"; }
cut2 "$V_SCREEN_QUEUE" 3  act2_a a
cut2 "$V_SCREEN_QUEUE" 20 act2_a b
cut2 "$V_SCREEN_QUEUE" 44 act2_b c
cut2 "$V_SCREEN_STL"   8  act2_b d
cut2 "$V_SCREEN_STL"   44 act2_c e

# 第三幕 留言慢放 + 双层字幕交替
ffmpeg -y -loglevel error -ss 8 -t 9 -i "$SRC/$V_COMMENTS.mp4" -loop 1 -t 9 -i "$OV/act3_sub1.png" -loop 1 -t 9 -i "$OV/act3_sub2.png" -filter_complex "[0:v]setpts=1.3*PTS,scale=$((FW*22/15)):-2,zoompan=z='min(zoom+0.0003,1.08)':d=1:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${FW}x${FH}:fps=30[bv];[1:v]format=rgba,fade=t=out:st=4.2:d=0.8:alpha=1[s1];[2:v]format=rgba,fade=t=in:st=4.5:d=1:alpha=1[s2];[bv][s1]overlay=0:0[b1];[b1][s2]overlay=0:0,format=yuv420p[v2]" -map "[v2]" -map 0:a -t 9 $ENC "$WORK/seg_act3.mp4"

# 第四幕 老师出镜 锐化+暗角（保留原声，b 段 5s 去卡顿）
cut4() { ffmpeg -y -loglevel error -ss "$2" -t "$3" -i "$SRC/$1.mp4" -i "$OV/$4.png" -filter_complex "[0:v]scale=$((FW+10)):$((FH+8)):force_original_aspect_ratio=increase,crop=${FW}:${FH},unsharp=5:5:0.8:5:5:0.0,vignette=PI/5,fps=30[bv];[bv][1:v]overlay=0:0,format=yuv420p[v2]" -map "[v2]" -map 0:a -t "$3" $ENC "$WORK/seg_act4_$5.mp4"; }
cut4 "$V_TEACHER_A" 0 6 act4_a a
cut4 "$V_TEACHER_B" 2 5 act4_b b
cut4 "$V_TEACHER_C" 1 6 act4_c c
cut4 "$V_TEACHER_D" 5 7 act4_d d

echo "== 4/6 尾声+落款+预告（黑底字卡） =="
card() { ffmpeg -y -loglevel error -f lavfi -i color=c=black:s=${FW}x${FH}:r=30:d="$2" -loop 1 -t "$2" -framerate 30 -i "$OV/$1.png" -f lavfi -i anullsrc=r=44100:cl=stereo -filter_complex "[1:v]format=rgba,fade=t=in:st=0:d=0.6:alpha=1,fade=t=out:st=$(echo "$2 - 1" | bc):d=1:alpha=1[ov];[0:v][ov]overlay=0:0,format=yuv420p[v2]" -map "[v2]" -map 2:a -t "$2" $ENC "$WORK/seg_$3.mp4"; }
ffmpeg -y -loglevel error -f lavfi -i color=c=black:s=${FW}x${FH}:r=30:d=12 -loop 1 -t 12 -framerate 30 -i "$OV/act5.png" -f lavfi -i anullsrc=r=44100:cl=stereo -filter_complex "[1:v]format=rgba,fade=t=in:st=0.5:d=1.2:alpha=1,fade=t=out:st=10.8:d=1.2:alpha=1[ov];[0:v][ov]overlay=0:0,format=yuv420p[v2]" -map "[v2]" -map 2:a -t 12 $ENC "$WORK/seg_act5.mp4"
card credits.png 4.5 credits
card next.png    4.5 next

echo "== 5/6 拼接 =="
: > "$WORK/concat.txt"
[ -n "$PROLOGUE_SEG" ] && echo "file '$PROLOGUE_SEG'" >> "$WORK/concat.txt"
for s in act1 act2_a act2_b act2_c act2_d act2_e act3 act4_a act4_b act4_c act4_d act5 credits next; do
  echo "file '$WORK/seg_$s.mp4'" >> "$WORK/concat.txt"
done
ffmpeg -y -loglevel error -f concat -safe 0 -i "$WORK/concat.txt" -c:v libx264 -preset veryfast -crf 20 -c:a aac -b:a 128k "$WORK/base.mp4"
DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$WORK/base.mp4")
FADE_ST=$(echo "$DUR - 4" | bc)

echo "== 6/6 配乐（sidechain 自动压低）+ 输出 =="
OUTFILE="$OUT/结课视频_成片.mp4"
ffmpeg -y -loglevel error -i "$WORK/base.mp4" -i "$BGM" -filter_complex "[1:a]atrim=0:$DUR,asetpts=PTS-STARTPTS,afade=t=in:st=0:d=1.5,afade=t=out:st=$FADE_ST:d=4[bgm0];[bgm0]volume=0.55[bgm];[0:a]asplit[voice][sc];[voice]volume=1.0[v];[bgm][sc]sidechaincompress=threshold=0.03:ratio=8:attack=80:release=500:makeup=1[ducked];[v][ducked]amix=inputs=2:duration=first:dropout_transition=2,loudnorm=I=-16:TP=-1.5:LRA=11[a]" -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k -t "$DUR" "$OUTFILE"
echo "完成: $OUTFILE (${DUR}s, ${FW}x${FH})"

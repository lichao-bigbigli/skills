#!/usr/bin/env python3
"""make_overlays.py — 生成结课视频所有字幕/字卡透明 PNG（Pillow，无需 ffmpeg drawtext）。

用法:
  python3 make_overlays.py                     # 默认 1920x1080，输出 ~/Desktop/A3结课视频/overlays
  python3 make_overlays.py --out DIR --w 1440 --h 1080 --font PATH

设计规范（用户确认过的偏好）:
- 字体: PingFang.ttc index=1（中黑/加粗档）
- 白底画面: 黑字/深蓝字 + 白色圆角衬底
- 深底画面: 白字 + 黑描边(3-6px) + 投影
- 代码统一蓝色 (80,160,255)
- 所有字幕预先渲染成全幅透明 PNG，由 ffmpeg overlay 烧录（本机 ffmpeg 9 无 drawtext 滤镜）

生成清单:
  act1.png / act5.png / credits.png / next.png   黑底字卡
  act2_{a,b,c}.png                               第二幕白衬底黑字
  act3_sub1.png / act3_sub2.png                  第三幕情书句 + 留言清单
  act4_{a,b,c,d}.png                             第四幕白字黑描边
  pre_sub{1,2,3}.png                             序章三句
"""
import argparse
import os
from PIL import Image, ImageDraw, ImageFont

ap = argparse.ArgumentParser()
ap.add_argument("--out", default=os.path.expanduser("~/Desktop/A3结课视频/overlays"))
ap.add_argument("--w", type=int, default=1920)
ap.add_argument("--h", type=int, default=1080)
ap.add_argument("--font", default=os.path.expanduser("~/Library/Fonts/PingFang.ttc"))
A = ap.parse_args()
os.makedirs(A.out, exist_ok=True)
W, H = A.w, A.h

BLUE = (80, 160, 255, 255)
DEEP_BLUE = (20, 60, 160, 255)
BLACK = (20, 20, 20, 255)
WHITE = (255, 255, 255, 255)
GRAY = (200, 200, 200, 255)
S = H / 1080.0  # 字号随画幅高度缩放


def gf(size):
    return ImageFont.truetype(A.font, int(size * S), index=1)


def shadow(d, xy, text, font, fill, stroke=3):
    d.text((xy[0] + 3, xy[1] + 3), text, font=font, fill=(0, 0, 0, 180), stroke_width=stroke, stroke_fill=(0, 0, 0, 180))
    d.text(xy, text, font=font, fill=fill, stroke_width=stroke, stroke_fill=fill)


def center_y(d, text, font, y, fill, stroke=3, box=None):
    bb = d.textbbox((0, 0), text, font=font)
    x = (W - (bb[2] - bb[0])) // 2
    if box:
        d.rounded_rectangle([x - 44, y - 24, x + (bb[2] - bb[0]) + 44, y + 96], radius=18, fill=box)
    shadow(d, (x, y), text, font, fill, stroke)


def card(lines, fname):
    """黑底字卡: lines=[(text,size,color,y_offset_ratio)]"""
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    for text, size, color, yr in lines:
        f = gf(size)
        bb = d.textbbox((0, 0), text, font=f)
        d.text(((W - (bb[2] - bb[0])) // 2, int(H * yr)), text, font=f, fill=color, stroke_width=2, stroke_fill=color)
    img.save(os.path.join(A.out, fname))


# ---- 第一幕 递推 ----
card([
    ("f[1] = 1;", 72, BLUE, 0.33),
    ("f[i] = f[i-1] + f[i-2];", 72, BLUE, 0.44),
    ("还记得吗？", 88, WHITE, 0.65),
    ("我们的第一节课，是递推", 64, WHITE, 0.77),
    ("那时候，每一步都踩着上一步的脚印", 48, GRAY, 0.86),
], "act1.png")

# ---- 第二幕 白衬底黑字 ----
subs2 = {"act2_a.png": "从队列到栈，从 STL 到一颗颗 AC",
         "act2_b.png": "一遍遍调试，一次次提交",
         "act2_c.png": "Wrong Answer 从来不是终点"}
for fname, sub in subs2.items():
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    center_y(d, sub, gf(66), int(H * 0.88), BLACK, stroke=2, box=(255, 255, 255, 215))
    img.save(os.path.join(A.out, fname))

# ---- 第三幕 留言（真实评价内容，勿虚构） ----
img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
d = ImageDraw.Draw(img)
d.rectangle([0, int(H * 0.8), W, H], fill=(0, 0, 0, 170))
center_y(d, "一页页留言，是你们写给这个班的情书", gf(62), int(H * 0.83), WHITE)
img.save(os.path.join(A.out, "act3_sub1.png"))

img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
d = ImageDraw.Draw(img)
d.rectangle([0, 0, W, H], fill=(0, 0, 0, 150))
rows = [
    ("09-26 20:59", "老师生日快乐！…一定要原版"),
    ("10-17 20:56", "到底有多少个\u201c所有人\u201d？我数不过来"),
    ("09-06 11:59", "读到我的时候，跳起来说一句下课"),
    ("08-22 20:56", "祝福所有的老师和同学！求上墙！"),
]
y = int(H * 0.28)
for ts, msg in rows:
    fts, fmsg = gf(44), gf(50)
    bts = d.textbbox((0, 0), ts, font=fts)
    bmsg = d.textbbox((0, 0), msg, font=fmsg)
    x = (W - (bts[2] - bts[0]) - 24 - (bmsg[2] - bmsg[0])) // 2
    shadow(d, (x, y + 6), ts, fts, BLUE, stroke=2)
    shadow(d, (x + (bts[2] - bts[0]) + 24, y), msg, fmsg, WHITE, stroke=2)
    y += int(H * 0.083)
center_y(d, "……这些话，我都记得。", gf(72), int(H * 0.70), WHITE, stroke=4)
img.save(os.path.join(A.out, "act3_sub2.png"))

# ---- 第四幕 白字黑描边 ----
subs4 = {"act4_a.png": "课程到这里，就要结束了",
         "act4_b.png": "最后一节课，是动态规划",
         "act4_c.png": "把大问题拆成小问题，把小答案存起来",
         "act4_d.png": "这不就是算法，也不就是成长吗"}
for fname, sub in subs4.items():
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    center_y(d, sub, gf(70), int(H * 0.87), WHITE, stroke=6)
    img.save(os.path.join(A.out, fname))

# ---- 第五幕 / 落款 / 预告 ----
card([
    ("第一节课：递推", 66, WHITE, 0.26),
    ("最后一节课：动态规划", 66, WHITE, 0.35),
    ("递推是把过去算给现在", 56, GRAY, 0.47),
    ("DP 是把回忆存起来，供未来取用", 56, GRAY, 0.56),
    ("dp[n] = best(dp[all the days we had]);", 62, BLUE, 0.685),
    ("结课快乐，我们更高处见", 80, WHITE, 0.815),
], "act5.png")

card([
    ("数据结构与高级算法", 84, WHITE, 0.41),
    ("2026 · 猿编程", 56, BLUE, 0.54),
    ("— 谢谢每一个认真听课的你 —", 44, GRAY, 0.65),
], "credits.png")

card([
    ("—— 我们的故事，未完待续 ——", 44, GRAY, 0.31),
    ("冲刺班 · 算法设计与程序优化", 80, WHITE, 0.42),
    ("等 你", 104, BLUE, 0.565),
], "next.png")

# ---- 序章字幕 ----
for fname, text, boxed in [("pre_sub1.png", "写下第一行代码的那天，你还记得吗？", True),
                           ("pre_sub2.png", "回车落下的那一声——", True),
                           ("pre_sub3.png", "一切，从这里开始", False)]:
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    if boxed:
        d.rectangle([0, int(H * 0.82), W, H], fill=(0, 0, 0, 150))
        center_y(d, text, gf(60), int(H * 0.865), WHITE)
    else:
        center_y(d, text, gf(72), int(H * 0.46), WHITE, stroke=5)
    img.save(os.path.join(A.out, fname))

print(f"ALL overlays -> {A.out} ({W}x{H})")

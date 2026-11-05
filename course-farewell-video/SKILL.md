---
name: course-farewell-video
description: 制作班级结课煽情视频的完整流水线（序章插画+五幕正片+落款+下期预告），用 ffmpeg 对真实课堂素材（老师出镜/课件录屏/学生留言）自动粗剪、烧字幕、配乐混音，输出成片 mp4。当用户提到"结课视频"、"煽情视频"、"课间放的视频"、"结课视频脚本/成片"、"班级纪念视频"，或给出课程录屏/出镜素材要求剪成纪念视频时使用——即使没有明说"煽情"或"结课"。
---

# 班级结课煽情视频流水线

把一学期沉淀的课堂素材（老师出镜口播、直播课件录屏、学生评价留言）自动剪成一条 1 分多钟的煽情成片：AI 插画序章 → 递推开场 → 课件快剪 → 留言催泪幕 → 老师寄语 → DP 尾声 → 落款卡 → 下期预告卡。此流程在猿编程 A3 班「数据结构与高级算法」结课项目中实际跑通并交付（v7 为用户最终采纳版）。

## 环境要求与前置检查

1. **ffmpeg 必须检查 drawtext 是否可用**：`ffmpeg -hide_banner -filters | grep drawtext`。本机 ffmpeg 9（homebrew）**没有** drawtext/libass——所以整套字幕方案是 **Pillow 预渲染透明 PNG + ffmpeg overlay**，不要尝试 drawtext，浪费时间。
2. 中文字体：默认用 `~/Library/Fonts/PingFang.ttc`（index=1 为加粗档）。可用 `fc-list | grep -i pingfang` 确认。
3. Pillow：`python3 -c "import PIL"`。所有文本渲染走 Pillow。

## 交付流程（先脚本后成片，两步交付）

### 第一步：先盘点素材、产出脚本文档

1. `ffprobe` 逐个检查素材：分辨率、时长、音轨有无。**注意 mp4 可能 moov atom 损坏**（`moov atom not found`）——损坏文件直接告知用户不可用，不要恋战。
2. 用 `ffmpeg fps=1/N` 抽帧 + Read 看内容，判断每段素材是什么（出镜口播 / 课件录屏 / 页面滚动录屏）。
3. 写脚本文档（Markdown）到素材同级目录，包含：素材盘点表、分镜（序章+五幕+落款+预告）、每幕画面/字幕/音效、制作要点。脚本中的字幕文案要给用户确认空间——尤其**老师出镜段的旁白字幕是代写文案，要明确提示用户"可提供老师原话替换"**。
4. 用户改脚本后（可能内嵌 base64 图片），用 `re.sub(r'!\[\]\(data:image/[^)]+\)', '[图片]', data)` 剥离后再读文本；内嵌图片可 base64 解码还原为素材使用。

### 第二步：按脚本合成成片

优先直接运行一键脚本：

```zsh
# 16:9（v7 标准结构）
~/.agents/skills/course-farewell-video/scripts/build_farewell_video.sh <素材目录> <输出目录> <BGM.mp3>

# 4:3
~/.agents/skills/course-farewell-video/scripts/build_farewell_video.sh <素材目录> <输出目录> <BGM.mp3> 1440 1080
```

素材文件名与默认不同时用环境变量覆盖：`V_TEACHER_A/B/C/D`（出镜×4）、`V_SCREEN_QUEUE/STL`（课件录屏）、`V_COMMENTS`（留言录屏）；可选 `PROLOGUE_IMG`（2x2 AI 插画，含底部字幕条，约 8.5% 高）、`RABBIT_IMG`（第一幕背景图）。

脚本不可用时按 `references/pipeline.md` 手工分步执行。

## 用户已确认的偏好（默认沿用，勿再询问）

- **保留原声**：老师出镜、课件片段全部带原始音频；BGM 用 sidechain ducking 自动压低（threshold=0.03, ratio=8），不问"要不要屏蔽原声"。
- **字幕风格**：加粗（PingFang index=1）；白底画面用黑字/深蓝字+白衬底；深底画面白字黑描边；代码统一蓝色。白底画面上禁止纯白字。
- **节奏**：1 分钟级快剪（课件每镜 3s）；BGM 《起风了》或《那些年》（用户桌面取），音量 0.55 + ducking，响度 loudnorm I=-16。
- **催泪素材**：第三幕必须引用**评价系统里的真实学生留言**（带原始时间戳，蓝色显示），去掉点歌类留言；不要编造"AC 记录/编译通过"这类与素材不符的文案——素材里是什么就写什么。
- **片尾三件套**：DP 尾声渐隐 → 落款卡（课程名/年份·品牌）→ 下期预告卡（"等 你"蓝色大字压轴）。
- **卡顿处理**：正片中段出现的卡顿帧直接删该段尾部（重裁该 clip），不做补帧。

## 已踩过的坑（重要）

1. **ffmpeg 无 drawtext** → 全部字幕走 Pillow PNG overlay；字幕显隐用 `overlay` 输入 `format=rgba,fade=t=in/out:...:alpha=1`，**必须先 `format=rgba` 再 fade**，否则 alpha fade 会让整帧变黑。
2. **`-filter_complex` 里带 `overlay=...:format=auto` 或从 shell 变量拼接** 在 ffmpeg 9 会报 `Filter 'format:default' has output unconnected`——filtergraph 一律写成字面量单行字符串，别把滤镜链放 shell 变量。
3. **大图 zoompan 极慢**（2304px PNG 会跑 3 分钟+）：先 `scale` 降到 ≤2300px 宽，再 `zoompan d=1` 逐帧。
4. **`-v error` 偶发误报** filtergraph 错误：去掉 `-v error` 用 `-loglevel error` 或默认日志跑一遍即可成功。
5. **concat 要求流一致**：无音轨的片段（黑屏字卡、图片动效）先补 `anullsrc` 静音轨再 concat。
6. **切片时长**：多段 3s 快剪片段拼好后用 `ffprobe` 核对总时长；成片音轨必须覆盖全片（`-t <总时长>`），否则结尾静音。
7. **画幅切换**：16:9→4:3 时所有片段（含字卡 overlay PNG）都要按新画幅重生成，字卡文字用 y 比例定位可自适应。

## 交付后

- 用 `ffmpeg -ss <t> -frames:v 1` 抽 6-10 个关键帧自查（序章、每幕、转场缝、片尾），确认无黑帧/字幕重叠/错位再交付。
- 交付时列明：成片路径、结构时间轴表、配乐选择、遗留项（如老师字幕是代写文案）。
- 中间产物（clips、base、overlays）保留在输出目录 `build/` 子目录，方便单段重剪；询问用户是否清理旧版本。

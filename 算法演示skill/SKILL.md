---
name: algorithm-visualizer
description: 算法可视化演示生成器 — 创建赛博朋克风格的算法动画演示页面。支持各种排序算法、搜索算法、数据结构演示。当用户需要制作算法演示、算法可视化、算法动画、教学演示时使用。触发词包括："算法演示"、"算法可视化"、"排序动画"、"算法教学"、"visualization"、"algorithm demo"、"sorting animation"。
---

# algorithm-visualizer — 算法可视化演示生成器

创建专业的赛博朋克风格算法演示页面。纯静态 HTML/CSS/JS，无需构建工具。

## 功能特性

- **赛博朋克视觉风格** — 霓虹灯效果、网格背景、发光边框
- **16:9 响应式容器** — 适合录屏和演示
- **完整的控制系统** — 开始/暂停/重置/加速/减速
- **实时统计面板** — 显示轮次、比较次数、交换次数、速度
- **状态可视化** — 不同颜色标识当前状态（比较中、最小值、已排序、未排序）
- **动画效果** — 平滑的过渡动画和状态变化
- **场景说明** — 实时显示当前执行的算法步骤
- **代码展示功能** — 点击 CODE 按钮查看算法的完整代码实现（C++/Python/Java 等）

## 已支持的算法

### 排序算法
- ✅ 选择排序 (Selection Sort)
- 🔄 冒泡排序 (Bubble Sort) - 开发中
- 🔄 插入排序 (Insertion Sort) - 开发中
- 🔄 快速排序 (Quick Sort) - 开发中
- 🔄 归并排序 (Merge Sort) - 开发中

### 搜索算法
- ✅ 二分查找 (Binary Search)

## 使用方法

### 基本使用

当用户请求创建算法演示时：

1. **识别算法类型** — 确认用户想要演示的具体算法
2. **选择模板** — 从 `templates/` 目录选择对应的算法模板
3. **自定义参数** — 根据用户需求调整：
   - 数组大小和初始值
   - 动画速度
   - 颜色主题
   - 显示的统计信息

### 示例对话

```
用户: 帮我做一个冒泡排序的演示动画
助手: [使用 bubble-sort 模板，创建赛博朋克风格的冒泡排序演示页面]

用户: 做一个二分查找的演示动画
助手: [使用 binary-search 模板，创建左右分栏布局，左侧动画演示，右侧显示核心代码]

用户: 我想要一个快速排序的可视化，数组大一点，要显示递归过程
助手: [使用 quick-sort 模板，增加数组大小，添加递归树可视化]
```

## 模板结构

### 标准模板布局（如 selection-sort.html）

### 1. HTML 结构
- `.main-container` — 16:9 主容器
- `.controls` — 控制按钮区
- `.scene-info` — 场景说明区
- `.visualization-container` — 可视化主区域
- `.stats-panel` — 统计面板（右上角）
- `.legend` — 图例说明

### 左右分栏布局（如 binary-search.html）

#### 特殊布局说明
二分查找等需要展示代码的算法使用左右分栏布局：

**HTML 结构：**
- `.main-container` — 16:9 主容器
  - `.stats-panel` — 统计面板（主容器右上角）
  - `.controls` — 控制按钮区
  - `.scene-info` — 场景说明区
  - `.content-wrapper` — 主内容区（flex 左右分栏）
    - `.visualization-container` — 左侧动画演示区（55%）
      - `.target-display` — 目标值显示
      - `.array-container` — 数组可视化
    - `.code-panel` — 右侧代码展示区（45%）
      - `.code-panel-header` — 代码标题
      - `.code-panel-content` — 代码内容（可滚动）
  - `.legend` — 图例说明

**关键样式特点：**
```css
/* 左右分栏容器 */
.content-wrapper {
  display: flex;
  gap: 1rem;
  flex: 1;
}

/* 左侧动画区 */
.visualization-container {
  flex: 1;  /* 占 55% */
}

/* 右侧代码区 */
.code-panel {
  width: 45%;
}

/* 统计面板 - 主容器右上角 */
.stats-panel {
  position: absolute;
  top: 0.5rem;
  right: 2rem;
  font-size: 0.7rem;
  z-index: 10;
}

/* 代码字体 - 较大便于阅读 */
.code-panel pre {
  font-size: 1rem;
  line-height: 1.8;
}
```

### 2. 核心样式特性

```css
/* 赛博朋克颜色系统 */
--cyber-cyan: #00ffff;      /* 主色调 */
--cyber-magenta: #ff00ff;   /* 强调色 */
--cyber-yellow: #ffd700;    /* 比较色 */
--cyber-green: #00ff00;     /* 完成色 */
--cyber-dark: #0a0e27;      /* 背景色 */

/* 霓虹发光效果 */
box-shadow: 
  0 0 10px rgba(255, 0, 255, 0.6),
  0 0 20px rgba(255, 0, 255, 0.3);

/* 网格背景动画 */
background: 
  linear-gradient(rgba(0, 255, 255, 0.03) 1px, transparent 1px),
  linear-gradient(90deg, rgba(0, 255, 255, 0.03) 1px, transparent 1px);
background-size: 50px 50px;
animation: gridScroll 10s linear infinite;
```

### 3. JavaScript 核心功能

```javascript
// 基础状态管理
let array = [];           // 数据数组
let animationSpeed = 1;   // 动画速度倍数
let isRunning = false;    // 运行状态
let isPaused = false;     // 暂停状态
let stats = {};          // 统计数据

// 核心函数
function initArray()           // 初始化数组
function renderArray()         // 渲染可视化
function updateSceneInfo()     // 更新场景说明
function updateStats()         // 更新统计信息
async function sleep(ms)       // 动画延迟
async function algorithmName() // 算法实现
```

### 4. 状态类系统

**排序算法状态：**
```css
.bar-wrapper.minimum     // 当前最小值（粉红色）
.bar-wrapper.comparing   // 正在比较（金黄色）
.bar-wrapper.sorted      // 已排序（绿色）
.bar-wrapper.unsorted    // 未排序（青色）
```

**搜索算法状态（二分查找）：**
```css
.bar-wrapper.mid         // 中间值（粉红色发光）
.bar-wrapper.left        // 左边界标记（金色 L 标签）
.bar-wrapper.right       // 右边界标记（金色 R 标签）
.bar-wrapper.in-range    // 搜索范围内（金黄色，深色数字）
.bar-wrapper.excluded    // 已排除（灰色半透明）
.bar-wrapper.found       // 找到目标（绿色脉冲动画）
```

**颜色对比度优化：**
- 黄色背景（搜索范围）使用深色数字 `#0a0e27`，移除发光效果
- 其他状态保持青色数字 `#00ffff` + 发光效果

### 5. 代码展示系统

**方式一：弹窗模式（适用于排序算法）**

需要完整屏幕空间展示动画时使用：

```html
<!-- 代码弹窗结构 -->
<div class="code-modal" id="codeModal">
  <div class="code-modal-content">
    <pre id="cppCode">
      <!-- 在这里放置算法的完整代码实现 -->
    </pre>
  </div>
</div>
```

```javascript
// 代码展示控制
showCodeBtn.addEventListener('click', () => {
  codeModal.classList.add('show');
});

// 点击背景或按 ESC 键关闭弹窗
codeModal.addEventListener('click', (e) => {
  if (e.target === codeModal) {
    codeModal.classList.remove('show');
  }
});
```

**方式二：侧边栏模式（适用于搜索算法）**

需要同时展示代码和动画时使用：

```html
<!-- 右侧代码面板 -->
<div class="code-panel">
  <div class="code-panel-header">◢ 核心算法 ◣</div>
  <div class="code-panel-content">
    <pre id="cppCode">
      <!-- 只展示核心算法代码，不包含 main 函数和示例 -->
    </pre>
  </div>
</div>
```

**代码内容原则：**
- 弹窗模式：展示完整代码（含头文件、main、示例、注释）
- 侧边栏模式：只展示核心算法函数（简洁清晰，字体较大）

## 代码展示功能

### 功能说明

每个算法演示页面都包含一个 **CODE 按钮**，点击后会弹出模态窗口，显示该算法的完整代码实现。这个功能帮助学习者在观看动画演示的同时，理解算法的具体代码实现。

### 代码弹窗样式

```css
.code-modal {
  /* 全屏覆盖层 */
  position: absolute;
  width: 100%;
  height: 100%;
  background-color: rgba(10, 14, 39, 0.95);
  animation: fadeIn 0.3s ease;
}

.code-modal-content {
  /* 代码容器 - 赛博朋克风格 */
  background: rgba(0, 0, 0, 0.9);
  border: 3px solid #ff00ff;
  width: 70%;
  max-height: 90%;
  padding: 2rem;
  box-shadow:
    0 0 30px rgba(255, 0, 255, 0.8),
    0 0 60px rgba(0, 255, 255, 0.5),
    inset 0 0 40px rgba(255, 0, 255, 0.1);
  overflow: auto;
}

.code-modal pre {
  /* 代码文本样式 */
  font-family: 'Courier New', monospace;
  font-size: 0.95rem;
  line-height: 1.8;
  color: #00ffff;
  text-shadow: 0 0 3px rgba(0, 255, 255, 0.5);
}
```

### 交互方式

用户可以通过以下三种方式关闭代码弹窗：

1. **点击背景区域** — 点击弹窗外的暗色背景
2. **点击代码区域** — 直接点击代码内容区域
3. **按 ESC 键** — 键盘快捷键关闭

### 代码内容结构

```html
<pre id="cppCode">#include &lt;iostream&gt;
#include &lt;vector&gt;
using namespace std;

void selectionSort(vector&lt;int&gt;& arr) {
    int n = arr.size();
    // 外层循环：遍历数组
    for (int i = 0; i &lt; n - 1; i++) {
        // 假设当前位置是最小值
        int minIndex = i;
        // 内层循环：在未排序区域查找最小值
        for (int j = i + 1; j &lt; n; j++) {
            if (arr[j] &lt; arr[minIndex]) {
                minIndex = j;
            }
        }
        // 如果找到更小的值，进行交换
        if (minIndex != i) {
            swap(arr[i], arr[minIndex]);
        }
    }
}

// 使用示例
int main() {
    vector&lt;int&gt; array = {64, 34, 25, 12, 22, 11, 90, 88, 45, 75};
    selectionSort(array);
    
    cout &lt;&lt; "排序后: ";
    for (int num : array) {
        cout &lt;&lt; num &lt;&lt; " ";
    }
    cout &lt;&lt; endl;
    return 0;
}</pre>
```

### 代码展示最佳实践

1. **添加详细注释** — 在代码中添加中文注释，帮助初学者理解
2. **包含完整示例** — 提供完整的可运行代码，包括 main 函数和测试数据
3. **与动画同步** — 使用与动画演示中相同的测试数据
4. **代码格式化** — 保持良好的缩进和代码风格
5. **HTML 转义** — 记得将 `<` 和 `>` 转义为 `&lt;` 和 `&gt;`

### 多语言代码支持（扩展）

如果想添加多语言代码切换功能：

```html
<!-- 添加语言切换按钮 -->
<div class="code-modal-content">
  <div class="language-tabs">
    <button class="lang-tab active" data-lang="cpp">C++</button>
    <button class="lang-tab" data-lang="python">Python</button>
    <button class="lang-tab" data-lang="java">Java</button>
  </div>
  
  <pre id="cppCode" class="code-block active">/* C++ 代码 */</pre>
  <pre id="pythonCode" class="code-block"><!-- Python 代码 --></pre>
  <pre id="javaCode" class="code-block"><!-- Java 代码 --></pre>
</div>
```

```javascript
// 语言切换功能
document.querySelectorAll('.lang-tab').forEach(tab => {
  tab.addEventListener('click', () => {
    const lang = tab.dataset.lang;
    
    // 更新激活状态
    document.querySelectorAll('.lang-tab').forEach(t => t.classList.remove('active'));
    tab.classList.add('active');
    
    // 显示对应代码
    document.querySelectorAll('.code-block').forEach(block => {
      block.classList.remove('active');
    });
    document.getElementById(`${lang}Code`).classList.add('active');
  });
});
```

## 自定义指南

### 调整数组数据

```javascript
// 默认数组
array = [64, 34, 25, 12, 22, 11, 90, 88, 45, 75];

// 随机数组
array = Array.from({length: 10}, () => Math.floor(Math.random() * 100));

// 有序数组（测试最优情况）
array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

// 逆序数组（测试最坏情况）
array = [100, 90, 80, 70, 60, 50, 40, 30, 20, 10];
```

### 调整动画速度

```javascript
// 默认速度倍数范围：0.25x - 4x
const MIN_SPEED = 0.25;
const MAX_SPEED = 4;

// 基础延迟时间（毫秒）
await sleep(600);  // 比较延迟
await sleep(1000); // 交换延迟
await sleep(400);  // 状态变化延迟
```

### 添加新的状态颜色

```css
/* 在 CSS 中添加新状态 */
.bar-wrapper.pivot .bar {
  background: linear-gradient(to top, #ff6600, #ff9900);
  border-color: #ff6600;
}

/* 在 JavaScript 中应用 */
if (highlights.pivot === index) {
  wrapper.classList.add('pivot');
}
```

### 自定义代码展示内容

```html
<!-- 在 <pre> 标签中添加你的算法代码 -->
<pre id="cppCode">#include &lt;iostream&gt;
#include &lt;vector&gt;
using namespace std;

void selectionSort(vector&lt;int&gt;& arr) {
    int n = arr.size();
    for (int i = 0; i &lt; n - 1; i++) {
        int minIndex = i;
        for (int j = i + 1; j &lt; n; j++) {
            if (arr[j] &lt; arr[minIndex]) {
                minIndex = j;
            }
        }
        if (minIndex != i) {
            swap(arr[i], arr[minIndex]);
        }
    }
}

int main() {
    vector&lt;int&gt; array = {64, 34, 25, 12, 22, 11, 90, 88, 45, 75};
    selectionSort(array);
    
    cout &lt;&lt; "排序后: ";
    for (int num : array) {
        cout &lt;&lt; num &lt;&lt; " ";
    }
    return 0;
}</pre>

<!-- 可以添加多个编程语言的版本 -->
<pre id="pythonCode">def selection_sort(arr):
    n = len(arr)
    for i in range(n - 1):
        min_index = i
        for j in range(i + 1, n):
            if arr[j] < arr[min_index]:
                min_index = j
        if min_index != i:
            arr[i], arr[min_index] = arr[min_index], arr[i]

# 示例
array = [64, 34, 25, 12, 22, 11, 90, 88, 45, 75]
selection_sort(array)
print("排序后:", array)</pre>
```

### 自定义柱状图样式

```css
.bar {
  width: 55px;                    /* 柱子宽度 */
  height: ${value * 3}px;         /* 高度倍数 */
  clip-path: polygon(0 0, 100% 0, 95% 100%, 5% 100%); /* 梯形效果 */
}
```

## 添加新算法

创建新算法演示的步骤：

### 1. 复制模板

```bash
cp templates/selection-sort.html templates/your-algorithm.html
```

### 2. 修改标题和说明

```html
<h1>◢ 你的算法名称 ◣</h1>
<p class="subtitle">// YOUR ALGORITHM NAME //</p>
```

### 3. 实现算法核心逻辑

```javascript
async function yourAlgorithm() {
  isRunning = true;
  // ... 初始化代码
  
  // 实现算法主逻辑
  // 在关键步骤：
  // 1. 更新 stats
  // 2. 调用 renderArray() 显示状态
  // 3. 调用 updateSceneInfo() 更新说明
  // 4. 调用 await sleep() 控制动画速度
  
  // ... 完成处理
  isRunning = false;
}
```

### 4. 添加代码展示按钮

```html
<!-- 在 controls 中添加 CODE 按钮 -->
<div class="controls">
  <button id="startBtn">▶ START</button>
  <button id="pauseBtn" disabled>⏸ PAUSE</button>
  <button id="resetBtn">↻ RESET</button>
  <button id="speedUpBtn">▶▶ SPEED UP</button>
  <button id="slowDownBtn">◀◀ SLOW DOWN</button>
  <button id="showCodeBtn">⚡ CODE</button>
</div>
```

### 5. 实现代码弹窗功能

```javascript
// 获取元素
const showCodeBtn = document.getElementById('showCodeBtn');
const codeModal = document.getElementById('codeModal');

// 显示代码弹窗
showCodeBtn.addEventListener('click', () => {
  codeModal.classList.add('show');
});

// 点击背景关闭弹窗
codeModal.addEventListener('click', (e) => {
  if (e.target === codeModal) {
    codeModal.classList.remove('show');
  }
});

// 点击代码区域也关闭弹窗
const codeContent = document.querySelector('.code-modal-content');
if (codeContent) {
  codeContent.addEventListener('click', () => {
    codeModal.classList.remove('show');
  });
}

// ESC键关闭弹窗
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && codeModal.classList.contains('show')) {
    codeModal.classList.remove('show');
  }
});
```

### 6. 示例：添加冒泡排序

```javascript
async function bubbleSort() {
  isRunning = true;
  const n = array.length;
  
  for (let i = 0; i < n - 1; i++) {
    stats.round = i + 1;
    updateStats();
    
    for (let j = 0; j < n - i - 1; j++) {
      if (!isRunning) break;
      
      stats.compares++;
      updateStats();
      
      // 高亮比较的两个元素
      renderArray({ comparing: j, comparing2: j + 1, sorted: n - i });
      await sleep(500);
      
      if (array[j] > array[j + 1]) {
        stats.swaps++;
        updateStats();
        
        // 交换
        [array[j], array[j + 1]] = [array[j + 1], array[j]];
        renderArray({ sorted: n - i });
        await sleep(800);
      }
    }
  }
  
  renderArray({ sorted: n });
  completionMessage.classList.add('show');
  isRunning = false;
}
```

## 视觉设计原则

### 颜色使用规范

- **青色 (#00ffff)** — 默认状态、未排序元素、未在范围内的元素
- **粉色 (#ff00ff)** — 关键元素（最小值、基准值、中间值、目标）
- **金色 (#ffd700)** — 当前比较的元素、搜索范围
- **绿色 (#00ff00)** — 已完成、已排序、找到目标
- **深色 (#0a0e27)** — 黄色背景上的数字（保证对比度）
- **灰色 (#333-#666)** — 已排除、不活跃的元素
- **橙色 (#ff6600)** — 可选：中间状态、警告状态

### 动画设计原则

1. **平滑过渡** — 使用 cubic-bezier 缓动函数
2. **视觉反馈** — 状态变化要有明显的动画效果
3. **关键帧强调** — 重要操作（交换、比较）要有视觉高亮
4. **速度可控** — 允许用户调整动画速度

### 布局比例

**标准单栏布局（排序算法）：**
```
标题区域：     10%
控制区域：     8%
场景说明：     10%
可视化主区：   62%
图例说明：     10%
```

**左右分栏布局（搜索算法）：**
```
标题区域：     8%
控制区域：     6%
场景说明：     8%
主内容区：     68%
  - 左侧动画：  55%
  - 右侧代码：  45%
图例说明：     10%
```

## 导出和分享

### 录制演示

推荐使用以下工具录制：
- **macOS**: QuickTime Player / ScreenFlow
- **Windows**: OBS Studio / Camtasia
- **Chrome**: 自带录屏功能 (Ctrl/Cmd + Shift + 5)

### 导出设置

- **分辨率**: 1920x1080 (16:9)
- **帧率**: 30fps 或 60fps
- **格式**: MP4 (H.264)

### 在线部署

```bash
# 直接部署到 GitHub Pages
# 或使用任何静态网站托管服务
# 文件已经是纯静态的，无需构建
```

## 性能优化建议

1. **数组大小** — 建议不超过 20 个元素，保证可视化清晰
2. **动画速度** — 默认 1x 适合演示，2x 适合快速预览
3. **浏览器** — 推荐使用 Chrome/Edge，硬件加速效果最佳
4. **CSS 动画** — 已优化使用 transform 和 opacity，GPU 加速

## 扩展功能建议

### 可以添加的功能

- 🎵 **音效** — 比较/交换时的音效反馈
- 📊 **复杂度图表** — 显示时间/空间复杂度曲线
- 🎮 **交互模式** — 让用户手动执行算法步骤
- 📝 **代码高亮** — 同步显示正在执行的代码行
- 🔄 **对比模式** — 同时演示两种算法进行对比
- 📱 **移动适配** — 适配手机竖屏显示
- 🌙 **主题切换** — 亮色/暗色/其他赛博朋克主题
- 💻 **多语言代码** — 在弹窗中切换查看不同编程语言的实现（C++/Python/Java/JavaScript）

## 常见问题

### Q: 如何调整容器大小？
A: 修改 `.main-container` 的 `max-width` 和 `aspect-ratio`

### Q: 如何修改字体？
A: 更改 `@import` 引入的 Google Fonts，并修改 `font-family`

### Q: 如何添加新的统计指标？
A: 在 `stats` 对象中添加字段，在 `.stats-panel` 中添加显示行，在算法中更新数值

### Q: 如何禁用背景动画？
A: 删除或注释掉 `@keyframes gridScroll` 和相关的 `animation` 属性

### Q: 动画卡顿怎么办？
A: 减少数组大小，降低动画复杂度，或使用 `will-change` CSS 属性优化性能

### Q: 如何修改代码展示的内容？
A: 编辑 `.code-modal-content` 中的 `<pre>` 标签内容，可以展示不同编程语言的实现

### Q: 如何添加多语言代码切换？
A: 创建多个 `<pre>` 标签（如 `#cppCode`, `#pythonCode`），添加语言选择按钮，通过 JavaScript 控制显示/隐藏

## 技术栈

- **HTML5** — 语义化结构
- **CSS3** — 动画、渐变、滤镜
- **Vanilla JavaScript** — 无依赖，纯原生实现
- **Google Fonts (Orbitron)** — 赛博朋克字体

## 许可

开源使用，可自由修改和分发。

## 更新日志

- **v1.1.0** (2026-06-17)
  - ✅ 新增二分查找算法模板
  - ✅ 左右分栏布局（左侧动画 + 右侧代码）
  - ✅ 搜索算法专用状态可视化
  - ✅ 统计面板优化（主容器右上角，与标题对齐）
  - ✅ 代码展示侧边栏模式
  - ✅ 黄色背景数字颜色对比度优化
  - ✅ 核心算法代码字体放大（1rem）

- **v1.0.0** (2026-06-16)
  - ✅ 初始版本
  - ✅ 选择排序模板
  - ✅ 赛博朋克视觉风格
  - ✅ 完整控制系统
  - ✅ 统计面板
  - ✅ 状态可视化
  - ✅ 代码展示功能（CODE 按钮弹窗）
  - ✅ 支持 ESC 键和点击关闭弹窗
  - ✅ C++ 代码完整实现展示

## 贡献

欢迎提交新的算法模板和视觉主题！

---

**开始使用**: 
- 排序算法：复制 `templates/selection-sort.html` 并根据你的算法修改核心逻辑
- 搜索算法：复制 `templates/binary-search.html` 使用左右分栏布局

# 算法可视化演示生成器

赛博朋克风格的算法动画演示工具，用于创建专业的算法教学和演示页面。

## 📦 文件结构

```
算法演示录制/
├── SKILL.md                    # Skill 定义和完整文档
├── README.md                   # 本文件
├── templates/                  # 模板文件夹
│   ├── template-base.html      # 通用基础模板
│   └── selection-sort.html     # 选择排序示例
└── SELECTION SORT.html         # 工作文件（可删除）
```

## 🚀 快速开始

### 方式一：使用 Claude Code 调用 Skill

在 Claude Code 对话中直接说：

```
帮我用算法可视化演示生成器做一个冒泡排序的动画
```

或

```
/algorithm-visualizer 创建一个快速排序演示
```

### 方式二：手动使用模板

1. **复制基础模板**
   ```bash
   cp templates/template-base.html my-algorithm.html
   ```

2. **修改标题**
   ```html
   <h1>◢ 你的算法名称 ◣</h1>
   <p class="subtitle">// YOUR ALGORITHM NAME //</p>
   ```

3. **实现算法逻辑**
   - 在 `runAlgorithm()` 函数中编写算法代码
   - 使用 `renderArray()` 更新可视化
   - 使用 `await sleep()` 控制动画速度
   - 使用 `updateSceneInfo()` 显示说明

4. **调整样式**（可选）
   - 修改颜色变量
   - 添加新的状态类
   - 调整动画效果

## 📖 使用示例

### 示例 1: 创建冒泡排序

```javascript
async function bubbleSort() {
  isRunning = true;
  const n = array.length;
  
  for (let i = 0; i < n - 1; i++) {
    updateSceneInfo(`第 ${i + 1} 轮`, `冒泡排序进行中...`);
    
    for (let j = 0; j < n - i - 1; j++) {
      if (!isRunning) break;
      
      stats.compares++;
      updateStats();
      
      // 高亮比较的元素
      renderArray({ highlight1: j, highlight2: j + 1, sorted: n - i });
      await sleep(500);
      
      if (array[j] > array[j + 1]) {
        stats.swaps++;
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

### 示例 2: 自定义状态颜色

在 CSS 中添加新状态：

```css
/* 基准值（快速排序） */
.bar-wrapper.pivot .bar {
  background: linear-gradient(to top, #ff6600, #ff9900);
  border-color: #ff6600;
  box-shadow:
    0 0 15px rgba(255, 102, 0, 0.9),
    0 0 30px rgba(255, 102, 0, 0.6);
}
```

在 JavaScript 中使用：

```javascript
renderArray({ pivot: pivotIndex, highlight1: i, highlight2: j });
```

## 🎨 视觉风格

### 颜色系统

- **青色 (#00ffff)** - 默认状态
- **粉色 (#ff00ff)** - 关键元素
- **金色 (#ffd700)** - 比较状态
- **绿色 (#00ff00)** - 完成状态

### 动画效果

- 网格背景滚动动画
- 扫描线效果
- 霓虹发光效果
- 平滑的状态过渡

## ⚙️ 配置选项

### 修改数组数据

```javascript
// 随机数组
array = Array.from({length: 10}, () => Math.floor(Math.random() * 100));

// 指定范围
array = Array.from({length: 15}, () => Math.floor(Math.random() * 50) + 10);

// 逆序数组（测试最坏情况）
array = Array(10).fill(0).map((_, i) => 100 - i * 10);
```

### 调整动画速度

```javascript
// 在 sleep() 调用中修改延迟时间
await sleep(500);  // 快速
await sleep(1000); // 正常
await sleep(2000); // 慢速
```

### 修改容器尺寸

```css
.main-container {
  max-width: 1920px;  /* 最大宽度 */
  aspect-ratio: 16 / 9;  /* 比例 */
}
```

## 🎯 核心 API

### 状态管理

```javascript
let array = [];           // 数据数组
let isRunning = false;    // 运行状态
let isPaused = false;     // 暂停状态
let animationSpeed = 1;   // 速度倍数（0.25x - 4x）
let stats = {             // 统计数据
  operations: 0,
  compares: 0,
  swaps: 0
};
```

### 核心函数

#### `initArray()`
初始化数组和状态

#### `renderArray(highlights)`
渲染可视化，highlights 参数：
```javascript
{
  highlight1: 索引,     // 高亮状态1（粉色）
  highlight2: 索引,     // 高亮状态2（金色）
  sorted: 数量,         // 已排序元素数量
  // 可添加自定义状态...
}
```

#### `updateSceneInfo(title, description)`
更新场景说明
- `title`: 场景标题
- `description`: 详细说明（可选）

#### `updateStats()`
更新统计面板显示

#### `async sleep(ms)`
延迟函数，支持暂停控制
- `ms`: 延迟时间（毫秒）
- 会自动根据 `animationSpeed` 调整

## 📝 开发清单

创建新算法演示时的检查清单：

- [ ] 复制模板文件
- [ ] 修改标题和副标题
- [ ] 设置初始数组数据
- [ ] 实现算法主逻辑
- [ ] 添加关键步骤的可视化
- [ ] 更新场景说明文字
- [ ] 调整动画延迟时间
- [ ] 自定义状态颜色（如需要）
- [ ] 更新图例说明
- [ ] 测试播放/暂停/重置功能
- [ ] 测试速度调整功能
- [ ] 测试边界情况

## 🎬 录制建议

### 推荐设置

- **分辨率**: 1920x1080
- **帧率**: 30fps 或 60fps
- **格式**: MP4 (H.264)
- **速度**: 1x（演示）或 2x（快速预览）

### 录制工具

- **macOS**: QuickTime Player, ScreenFlow
- **Windows**: OBS Studio, Camtasia  
- **Chrome**: 内置录屏 (Ctrl/Cmd + Shift + 5)

### 录制步骤

1. 打开 HTML 文件到全屏
2. F11 进入浏览器全屏模式
3. 开始录制
4. 点击 START 按钮
5. 等待算法完成
6. 停止录制

## 🔧 故障排查

### 问题：动画卡顿

**解决方法**：
- 减少数组大小
- 增加 sleep 延迟时间
- 使用 Chrome 浏览器
- 关闭其他标签页

### 问题：柱子重叠

**解决方法**：
- 减少数组元素数量
- 调整 `.bar` 的 width
- 调整 `.array-container` 的 gap

### 问题：文字显示不完整

**解决方法**：
- 确保引入了 Google Fonts
- 检查网络连接
- 使用本地字体作为后备

### 问题：暂停不工作

**解决方法**：
- 确保所有 `sleep()` 调用都使用了 `await`
- 检查循环中是否有 `if (!isRunning) break`

## 📚 参考资源

### 算法可视化灵感

- [VisuAlgo](https://visualgo.net/)
- [Algorithm Visualizer](https://algorithm-visualizer.org/)
- [Sorting Algorithms Animations](https://www.toptal.com/developers/sorting-algorithms)

### 赛博朋克设计

- [Cyberpunk Color Palette](https://www.color-hex.com/color-palette/1018397)
- [Neon Text Effects](https://css-tricks.com/how-to-create-neon-text-with-css/)

### 动画技术

- [CSS Animations Guide](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations)
- [JavaScript Async/Await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)

## 🤝 贡献

欢迎贡献新的算法模板！

提交新算法时请包含：
- 完整的 HTML 文件
- 算法说明和时间复杂度
- 测试用例（最好、平均、最坏情况）

## 📄 许可

MIT License - 自由使用和修改

## 📞 支持

遇到问题？
1. 查看 `SKILL.md` 完整文档
2. 检查浏览器控制台错误
3. 参考 `templates/selection-sort.html` 示例

---

**Created with ❤️ for algorithm education**
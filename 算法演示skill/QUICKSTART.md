# 快速开始指南

## 5分钟创建你的第一个算法演示

### 步骤 1：选择使用方式

#### 方式 A：通过 Claude Code 对话（推荐）

直接在对话中说：

```
帮我做一个冒泡排序的赛博朋克风格演示动画
```

或者

```
创建一个插入排序可视化，数组大小15，要显示每一步的比较过程
```

Claude 会自动使用这个 skill 生成完整的 HTML 文件。

#### 方式 B：手动创建

```bash
# 1. 复制基础模板
cp templates/template-base.html my-sort.html

# 2. 用浏览器打开
open my-sort.html  # macOS
start my-sort.html # Windows
```

### 步骤 2：实现算法（仅方式B需要）

在 `my-sort.html` 中找到 `runAlgorithm()` 函数，替换为你的算法：

```javascript
async function runAlgorithm() {
  isRunning = true;
  isPaused = false;
  startBtn.disabled = true;
  pauseBtn.disabled = false;
  const n = array.length;

  // 你的算法开始
  for (let i = 0; i < n - 1; i++) {
    for (let j = 0; j < n - i - 1; j++) {
      if (!isRunning) break;
      
      // 更新统计
      stats.compares++;
      updateStats();
      
      // 显示比较过程
      updateSceneInfo(`第 ${i+1} 轮`, `比较 ${array[j]} 和 ${array[j+1]}`);
      renderArray({ highlight1: j, highlight2: j+1 });
      await sleep(600);
      
      // 如果需要交换
      if (array[j] > array[j + 1]) {
        stats.swaps++;
        [array[j], array[j + 1]] = [array[j + 1], array[j]];
        renderArray({});
        await sleep(800);
      }
    }
  }
  
  // 显示完成
  if (isRunning) {
    renderArray({ sorted: n });
    completionMessage.classList.add('show');
  }
  
  startBtn.disabled = false;
  pauseBtn.disabled = true;
  isRunning = false;
}
```

### 步骤 3：测试运行

1. 在浏览器中打开文件
2. 点击 **START** 按钮
3. 观察动画效果
4. 使用控制按钮：
   - **PAUSE** - 暂停/继续
   - **RESET** - 重置到初始状态
   - **SPEED UP** - 加快速度（最高 4x）
   - **SLOW DOWN** - 减慢速度（最低 0.25x）

### 步骤 4：录制（可选）

#### macOS 用户

1. 按 `Cmd + Shift + 5` 打开录屏工具
2. 选择录制区域
3. 点击录制按钮
4. 在浏览器中运行演示
5. 完成后点击停止

#### Windows 用户

1. 按 `Win + G` 打开 Xbox Game Bar
2. 点击录制按钮
3. 在浏览器中运行演示
4. 完成后停止录制

#### Chrome 任何平台

1. 使用扩展如 Loom 或 Nimbus Screenshot
2. 或者使用 OBS Studio（免费专业工具）

## 常用代码片段

### 修改初始数组

在 `initArray()` 函数中：

```javascript
// 固定数组
array = [64, 34, 25, 12, 22, 11, 90, 88, 45, 75];

// 随机数组（10个，范围0-100）
array = Array.from({length: 10}, () => Math.floor(Math.random() * 100));

// 随机数组（15个，范围10-90）
array = Array.from({length: 15}, () => Math.floor(Math.random() * 80) + 10);

// 接近有序（测试最优情况）
array = [10, 15, 20, 18, 30, 35, 32, 50, 60, 55];

// 完全逆序（测试最坏情况）
array = [100, 90, 80, 70, 60, 50, 40, 30, 20, 10];
```

### 添加自定义状态颜色

CSS 部分添加：

```css
.bar-wrapper.pivot .bar {
  background: linear-gradient(to top, #ff6600, #ff9900);
  border-color: #ff6600;
  box-shadow: 0 0 15px rgba(255, 102, 0, 0.9);
}
```

JavaScript 使用：

```javascript
renderArray({ pivot: 5, highlight1: 2, highlight2: 8 });
```

### 调整动画速度

```javascript
// 快速比较
await sleep(300);

// 正常比较
await sleep(600);

// 慢速详细展示
await sleep(1200);

// 快速交换
await sleep(500);

// 正常交换
await sleep(800);
```

## 完整示例：二分查找

```javascript
// 修改 initArray()
function initArray() {
  array = [5, 12, 23, 34, 45, 56, 67, 78, 89, 95]; // 有序数组
  target = 45; // 查找目标
  stats = { operations: 0, compares: 0, swaps: 0 };
  updateStats();
  renderArray();
  updateSceneInfo('SYSTEM READY', `查找目标: ${target}`);
}

// 实现二分查找
async function binarySearch() {
  isRunning = true;
  let left = 0;
  let right = array.length - 1;
  
  while (left <= right) {
    if (!isRunning) break;
    
    const mid = Math.floor((left + right) / 2);
    
    stats.compares++;
    updateStats();
    
    updateSceneInfo(
      '二分查找',
      `查找范围 [${left}~${right}]，中间位置 ${mid}，值 ${array[mid]}`
    );
    
    renderArray({ 
      highlight1: mid,
      highlight2: left,
      pivot: right 
    });
    await sleep(1000);
    
    if (array[mid] === target) {
      updateSceneInfo('找到了！', `目标 ${target} 在位置 ${mid}`);
      renderArray({ highlight1: mid });
      completionMessage.textContent = '◢ FOUND ◣';
      completionMessage.classList.add('show');
      break;
    } else if (array[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  if (left > right && isRunning) {
    updateSceneInfo('未找到', `目标 ${target} 不在数组中`);
  }
  
  isRunning = false;
}
```

## 调试技巧

### 在浏览器控制台查看状态

按 `F12` 打开开发者工具，在 Console 中输入：

```javascript
// 查看当前数组
console.log(array);

// 查看统计信息
console.log(stats);

// 查看运行状态
console.log({isRunning, isPaused, animationSpeed});

// 手动触发渲染
renderArray({ highlight1: 3, highlight2: 7 });
```

### 添加调试日志

在算法中添加：

```javascript
console.log(`正在比较 array[${i}]=${array[i]} 和 array[${j}]=${array[j]}`);
```

### 单步测试

将所有 `await sleep()` 改为更长的延迟：

```javascript
await sleep(3000); // 3秒，方便观察每一步
```

## 下一步

- 📖 阅读 [SKILL.md](SKILL.md) 了解完整功能
- 📚 查看 [README.md](README.md) 深入学习
- 🎨 参考 [templates/selection-sort.html](templates/selection-sort.html) 完整示例
- 🚀 创建自己的算法演示

## 需要帮助？

在 Claude Code 中直接问：

```
我的冒泡排序动画为什么不动了？
如何让快速排序显示递归过程？
怎么添加一个新的橙色状态？
```

---

**开始创作你的算法演示吧！** 🎬✨

# Windows 文件迁移工具 - 设计系统规范文档

> **版本**: v1.0.0  
> **更新日期**: 2026-06-26  
> **设计风格**: Windows 11 Fluent Design System  
> **适用范围**: 桌面端和移动端

---

## 📋 目录

1. [设计系统规范](#1-设计系统规范)
2. [组件库规范](#2-组件库规范)
3. [交互标准](#3-交互标准)
4. [附录：设计规范检查清单](#4-附录设计规范检查清单)

---

## 1. 设计系统规范

### 1.1 色彩规范

#### 1.1.1 主色调

| 色彩名称 | 色值 | 使用场景 | 示例 |
|---------|--------|---------|------|
| **Primary** | `#0066CC` | 主要按钮、链接、激活状态 | ![Primary]() |
| **Primary Hover** | `#0052A3` | 主色悬停状态 | - |
| **Primary Active** | `#003D7A` | 主色按下状态 | - |
| **Primary Light** | `#E8F1FF` | 背景高亮、选中状态 | - |

#### 1.1.2 功能色

| 功能 | 色值 | Light 变体 | 使用场景 |
|------|------|------------|---------|
| **Success** | `#0D6832` | `#E6F7ED` | 成功提示、完成状态 |
| **Warning** | `#8A5700` | `#FFF4E6` | 警告提示、需要注意 |
| **Danger** | `#C4314B` | `#FDE7EB` | 错误提示、危险操作 |
| **Info** | `#0369A1` | `#E0F2FE` | 信息提示、帮助文本 |

#### 1.1.3 中性色

| 色阶 | 色值 | 使用场景 |
|-------|------|---------|
| **Gray 0** | `#FFFFFF` | 纯白背景 |
| **Gray 10** | `#F9FAFB` | 页面背景 |
| **Gray 20** | `#F3F4F6` | 悬停背景 |
| **Gray 30** | `#E5E7EB` | 边框、分割线 |
| **Gray 40** | `#D1D5DB` | 禁用状态边框 |
| **Gray 50** | `#9CA3AF` | 占位文本、禁用文本 |
| **Gray 60** | `#6B7280` | 次要文本 |
| **Gray 70** | `#4B5563` | 正文文本 |
| **Gray 80** | `#374151` | 标题文本 |
| **Gray 90** | `#1F2937` | 主要文本 |
| **Gray 100** | `#111827` | 纯黑文本 |

#### 1.1.4 渐变色

```css
/* 主渐变 */
--gradient-primary: linear-gradient(135deg, #0066CC, #0099FF);

/* 卡片悬停渐变 */
--gradient-card-hover: linear-gradient(to right, #E8F1FF, #FFFFFF);

/*  logo 渐变 */
--gradient-logo: linear-gradient(135deg, #0066CC, #004499);
```

#### 1.1.5 色彩使用规则

✅ **必须遵守**：
- 主色只能用于：主要按钮、激活状态、链接
- 功能色必须与语义匹配：绿色=成功，红色=错误，橙色=警告，蓝色=信息
- 中性色用于：文本、背景、边框
- 确保所有文本与背景的对比度 ≥ 4.5:1（WCAG AA 标准）

❌ **禁止**：
- 禁止在主色上使用过多鲜艳的色彩
- 禁止在低对比度的背景上使用浅色文本
- 禁止在单个页面使用超过 3 种主色调

---

### 1.2 字体规范

#### 1.2.1 字体族

```css
/* 优先顺序 */
font-family: 
    'Inter',                              /* 英文首选 */
    -apple-system,                         /* macOS */
    BlinkMacSystemFont,                    /* macOS */
    'Segoe UI',                           /* Windows */
    'PingFang SC',                        /* 中文 macOS */
    'Microsoft YaHei',                    /* 中文 Windows */
    sans-serif;                            /* 兜底 */
```

#### 1.2.2 字体大小阶梯

| 用途 | 字号 | 行高 | 字重 | 字母间距 |
|------|------|------|------|----------|
| **H1 - 页面标题** | 28px | 1.2 | 700 | -0.5px |
| **H2 - 卡片标题** | 20px | 1.3 | 600 | -0.3px |
| **H3 - 小标题** | 16px | 1.4 | 600 | 0 |
| **Body - 正文** | 14px | 1.6 | 400 | 0 |
| **Body - 强调** | 14px | 1.6 | 550 | 0 |
| **Small - 辅助文本** | 13px | 1.5 | 450 | 0.1px |
| **XS - 标签/标注** | 12px | 1.4 | 500 | 0.2px |
| **XXS - 版权信息** | 11px | 1.3 | 600 | 0.5px (大写) |

#### 1.2.3 字重使用规范

| 字重 | 数值 | 使用场景 |
|------|------|---------|
| **Light** | 300 | 大号标题（可选） |
| **Regular** | 400 | 正文、描述文本 |
| **Medium** | 500 | 标签、小标题 |
| **Semibold** | 550 | 链接、按钮文本 |
| **Bold** | 600 | 卡片标题、导航项 |
| **Extrabold** | 700 | 页面主标题 |

#### 1.2.4 文本颜色规范

```css
--text-primary: #111827;    /* Gray 100 - 主要文本 */
--text-secondary: #4B5563;  /* Gray 70 - 次要文本 */
--text-tertiary: #9CA3AF;   /* Gray 50 - 辅助文本 */
--text-placeholder: #9CA3AF; /* Gray 50 - 占位符 */
--text-disabled: #D1D5DB;   /* Gray 40 - 禁用文本 */
--text-link: #0066CC;        /* Primary - 链接 */
--text-success: #0D6832;    /* Success - 成功文本 */
--text-warning: #8A5700;    /* Warning - 警告文本 */
--text-danger: #C4314B;     /* Danger - 错误文本 */
```

#### 1.2.5 字体使用规则

✅ **必须遵守**：
- 中文使用 `PingFang SC` (macOS) 或 `Microsoft YaHei` (Windows)
- 英文使用 `Inter` 或 `Segoe UI`
- 数字使用 `Inter` 或 `Roboto Mono`（等宽数字）
- 代码使用 `Consolas` 或 `Monaco`

❌ **禁止**：
- 禁止在正文中使用超过 2 种字体族
- 禁止在单个段落中混用超过 2 种字重
- 禁止使用小于 12px 的字体（移动端最小 14px）

---

### 1.3 间距与布局规范

#### 1.3.1 间距系统（4px 基准）

```css
--spacing-0: 0px;
--spacing-px: 1px;
--spacing-0-5: 2px;   /* 0.5 × 4px */
--spacing-1: 4px;      /* 1 × 4px */
--spacing-1-5: 6px;   /* 1.5 × 4px */
--spacing-2: 8px;      /* 2 × 4px */
--spacing-2-5: 10px;  /* 2.5 × 4px */
--spacing-3: 12px;     /* 3 × 4px */
--spacing-3-5: 14px;  /* 3.5 × 4px */
--spacing-4: 16px;     /* 4 × 4px */
--spacing-5: 20px;     /* 5 × 4px */
--spacing-6: 24px;     /* 6 × 4px */
--spacing-8: 32px;     /* 8 × 4px */
--spacing-10: 40px;    /* 10 × 4px */
--spacing-12: 48px;    /* 12 × 4px */
--spacing-16: 64px;    /* 16 × 4px */
```

#### 1.3.2 布局间距应用

| 元素 | 间距 | 说明 |
|------|------|------|
| **页面边距（桌面端）** | 32px (spacing-8) | 内容区左右边距 |
| **页面边距（移动端）** | 16px (spacing-4) | 内容区左右边距 |
| **卡片内边距** | 24px (spacing-6) | 标准卡片 padding |
| **卡片间距** | 24px (spacing-6) | 卡片之间的间距 |
| **表单项间距** | 16px (spacing-4) | 相邻输入框的间距 |
| **按钮组间距** | 12px (spacing-3) | 相邻按钮的间距 |
| **图标与文本间距** | 8px (spacing-2) | 图标与配套文本的间距 |

#### 1.3.3 圆角规范

```css
--radius-xs: 2px;    /* 小标签、badge */
--radius-sm: 4px;    /* 输入框、小按钮 */
--radius-md: 8px;    /* 标准按钮、卡片 */
--radius-lg: 12px;   /* 大卡片、对话框 */
--radius-xl: 16px;   /* 大型容器 */
--radius-2xl: 20px;  /* 特殊容器 */
--radius-full: 9999px; /* 胶囊按钮、头像 */
```

#### 1.3.4 阴影规范

```css
--shadow-xs: 0 1px 2px rgba(0, 0, 0, 0.04);
--shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06), 
             0 1px 2px rgba(0, 0, 0, 0.04);
--shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07), 
             0 2px 4px rgba(0, 0, 0, 0.06);
--shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1), 
             0 4px 6px rgba(0, 0, 0, 0.05);
--shadow-xl: 0 20px 25px rgba(0, 0, 0, 0.12), 
             0 10px 10px rgba(0, 0, 0, 0.06);
--shadow-2xl: 0 25px 50px rgba(0, 0, 0, 0.18);
```

**阴影使用场景**：
- `shadow-xs`: 输入框、分隔线
- `shadow-sm`: 卡片默认状态
- `shadow-md`: 卡片悬停状态、下拉菜单
- `shadow-lg`: 对话框、弹出层
- `shadow-xl`: 全局提示、向导
- `shadow-2xl`: 全屏模态框

#### 1.3.5 布局网格

**桌面端**：
- 最大宽度：1440px
- 侧边栏宽度：260px（固定）
- 主内容区：自适应（1fr）
- 栅格系统：12 列，间距 24px

**移动端**：
- 侧边栏：全屏覆盖（260px 宽）
- 主内容区：100% 宽度
- 栅格系统：4 列，间距 16px

---

### 1.4 图标规范

#### 1.4.1 图标库

**推荐使用**：
- **Font Awesome 6** - 通用图标库（当前原型使用）
- **Fluent UI System Icons** - Windows 11 官方图标（推荐）
- **Material Icons** - 备用方案

#### 1.4.2 图标尺寸

| 用途 | 尺寸 | 笔画宽度 |
|------|------|---------|
| **小图标（表格、列表）** | 16px | 2px |
| **标准图标（按钮、导航）** | 20px | 2px |
| **大图标（空状态、引导）** | 24px | 1.5px |
| **超大图标（成功提示）** | 48px | 1.5px |

#### 1.4.3 图标颜色

```css
--icon-default: #6B7280;     /* Gray 60 - 默认 */
--icon-primary: #0066CC;     /* Primary - 主色图标 */
--icon-success: #0D6832;     /* Success - 成功图标 */
--icon-warning: #8A5700;     /* Warning - 警告图标 */
--icon-danger: #C4314B;      /* Danger - 错误图标 */
--icon-disabled: #D1D5DB;   /* Gray 40 - 禁用图标 */
```

#### 1.4.4 图标使用规则

✅ **必须遵守**：
- 图标必须与配套文本保持 8px 间距
- 图标应对策略：所有图标必须使用 `currentColor` 继承父元素颜色
- 功能图标（如关闭、删除）必须有 `title` 属性或 `aria-label`

❌ **禁止**：
- 禁止在同一行混用超过 2 种图标尺寸
- 禁止使用描边宽度不一致的图标
- 禁止使用像素化、模糊的图标

---

### 1.5 动效规范

#### 1.5.1 动画时长

```css
--transition-fast: 150ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-normal: 250ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-slow: 350ms cubic-bezier(0.4, 0, 0.2, 1);
```

**时长使用场景**：
- `150ms` - 悬停效果、颜色变化
- `250ms` - 展开/收起、淡入淡出
- `350ms` - 页面切换、大型元素移动

#### 1.5.2 缓动函数

```css
/* 标准缓动 - 用于大多数过渡 */
--ease-standard: cubic-bezier(0.4, 0, 0.2, 1);

/* 强调缓动 - 用于进入动画 */
--ease-emphasized: cubic-bezier(0.05, 0.7, 0.1, 1.0);

/* 减速缓动 - 用于退出动画 */
--ease-decelerated: cubic-bezier(0.0, 0.0, 0.2, 1);
```

#### 1.5.3 标准动画

```css
/* 淡入 */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

/* 从下方滑入 */
@keyframes slideUp {
    from { 
        opacity: 0; 
        transform: translateY(8px); 
    }
    to { 
        opacity: 1; 
        transform: translateY(0); 
    }
}

/* 从右侧滑入 */
@keyframes slideInRight {
    from { 
        opacity: 0; 
        transform: translateX(100px); 
    }
    to { 
        opacity: 1; 
        transform: translateX(0); 
    }
}

/* 旋转（加载指示器） */
@keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

/* 脉冲（进度条） */
@keyframes shimmer {
    0% { transform: translateX(-100%); }
    100% { transform: translateX(100%); }
}
```

#### 1.5.4 动效使用规则

✅ **必须遵守**：
- 所有过渡必须使用 `cubic-bezier(0.4, 0, 0.2, 1)` 缓动
- 页面切换动画时长 ≤ 350ms
- 悬停效果必须使用 `150ms` 快速响应
- 加载动画必须可访问 `prefers-reduced-motion`

❌ **禁止**：
- 禁止在单个页面使用超过 3 种不同的缓动函数
- 禁止动画时长超过 500ms（除非是特殊庆祝动画）
- 禁止在移动端使用复杂的物理模拟动画（耗性能）

---

## 2. 组件库规范

### 2.1 基础组件

#### 2.1.1 按钮 (Button)

**组件结构**：
```html
<button class="button [primary|secondary|danger|ghost] [size-sm|size-lg] [disabled]">
    <i class="icon"></i>
    <span>按钮文本</span>
</button>
```

**变体**：

| 变体 | 类名 | 使用场景 | 示例 |
|------|------|---------|------|
| **主要按钮** | `.button.primary` | 主要操作（提交、确认） | 🔵 |
| **次要按钮** | `.button` | 次要操作（取消、返回） | ⚪ |
| **危险按钮** | `.button.danger` | 危险操作（删除、重置） | 🔴 |
| **幽灵按钮** | `.button.ghost` | 低优先级操作 | 🔘 |

**尺寸**：

| 尺寸 | 类名 | 高度 | 内边距 | 字号 |
|------|------|------|--------|------|
| **小** | `.size-sm` | 32px | 8px 12px | 13px |
| **标准** | - | 40px | 10px 20px | 14px |
| **大** | `.size-lg` | 48px | 12px 24px | 16px |

**状态**：
- `:hover` - 颜色加深 10%
- `:active` - 颜色加深 20%，缩放 0.98
- `:disabled` - 透明度 60%，禁止点击
- `:focus` - 外部轮廓 3px 半透明主色

**使用规则**：
- ✅ 同一行按钮数量 ≤ 3 个
- ✅ 主要按钮在左侧，次要按钮在右侧
- ❌ 禁止在同一区域使用 2 个主要按钮

---

#### 2.1.2 输入框 (Input)

**组件结构**：
```html
<div class="form-group">
    <label class="form-label">标签文本</label>
    <div class="input-group [has-icon|has-button]">
        <i class="input-icon"></i>
        <input type="text" class="form-input" placeholder="占位文本">
        <button class="input-button"></button>
    </div>
    <span class="form-hint">提示文本</span>
    <span class="form-error">错误文本</span>
</div>
```

**状态**：

| 状态 | 边框色 | 背景色 | 示例 |
|------|--------|--------|------|
| **默认** | Gray 300 | White | - |
| **聚焦** | Primary | White | 蓝色边框 + 阴影 |
| **成功** | Success | Success Light | 绿色边框 |
| **错误** | Danger | Danger Light | 红色边框 + 错误文本 |
| **禁用** | Gray 300 | Gray 100 | 灰色背景 |

**使用规则**：
- ✅ 输入框必须有 `<label>`
- ✅ 占位文本必须使用浅色（Gray 500）
- ✅ 错误文本必须出现在输入框下方
- ❌ 禁止在单个表单使用超过 1 个占位文本

---

#### 2.1.3 复选框与单选框 (Checkbox / Radio)

**复选框结构**：
```html
<label class="checkbox">
    <input type="checkbox" checked>
    <span class="checkbox-mark"></span>
    <span class="checkbox-label">选项文本</span>
</label>
```

**单选框结构**：
```html
<label class="radio">
    <input type="radio" name="group" checked>
    <span class="radio-mark"></span>
    <span class="radio-label">选项文本</span>
</label>
```

**使用规则**：
- ✅ 复选框组必须有 `fieldset` + `legend`
- ✅ 单选框组必须有相同的 `name` 属性
- ❌ 禁止单独使用单个单选框（至少 2 个）

---

#### 2.1.4 切换开关 (Toggle)

**组件结构**：
```html
<label class="toggle">
    <input type="checkbox" checked>
    <span class="toggle-slider"></span>
</label>
```

**使用场景**：
- ✅ 用于即时生效的二进制设置（开/关）
- ❌ 禁止用于需要确认的操作（应使用按钮）

---

#### 2.1.5 下拉菜单 (Dropdown)

**组件结构**：
```html
<div class="dropdown">
    <button class="dropdown-trigger">
        <span>选中项</span>
        <i class="fas fa-chevron-down"></i>
    </button>
    <div class="dropdown-menu">
        <div class="dropdown-item [active]">选项 1</div>
        <div class="dropdown-item">选项 2</div>
        <div class="dropdown-divider"></div>
        <div class="dropdown-item danger">删除</div>
    </div>
</div>
```

**使用规则**：
- ✅ 下拉菜单最大高度 300px，超出则滚动
- ✅ 选中项必须有 `.active` 状态
- ❌ 禁止在下拉菜单中使用超过 10 个选项（应使用搜索框）

---

### 2.2 复合组件

#### 2.2.1 卡片 (Card)

**组件结构**：
```html
<div class="card">
    <div class="card-header">
        <h2 class="card-title">卡片标题</h2>
        <button class="card-action">操作</button>
    </div>
    <div class="card-content">
        <!-- 内容区域 -->
    </div>
    <div class="card-footer">
        <!-- 底部操作 -->
    </div>
</div>
```

**变体**：

| 变体 | 类名 | 说明 |
|------|------|------|
| **标准卡片** | `.card` | 白色背景、灰色边框、圆角 12px |
| **悬浮卡片** | `.card.elevated` | 无边框、阴影 md |
| **交互卡片** | `.card.interactive` | 悬停时阴影 lg + 上移 2px |

**使用规则**：
- ✅ 卡片内边距统一 24px
- ✅ 卡片标题字号 16px、字重 600
- ❌ 禁止在卡片内使用多层嵌套卡片

---

#### 2.2.2 表单 (Form)

**组件结构**：
```html
<form class="form">
    <div class="form-section">
        <h3 class="form-section-title"> section 标题</h3>
        <div class="form-group">
            <!-- 表单项 -->
        </div>
    </div>
    <div class="form-actions">
        <button class="button secondary">取消</button>
        <button class="button primary">提交</button>
    </div>
</form>
```

**布局规则**：
- 标签位置：顶部对齐（移动端）、右侧对齐（桌面端）
- 表单项间距：16px
- Section 间距：32px

---

#### 2.2.3 对话框 (Dialog / Modal)

**组件结构**：
```html
<div class="dialog-overlay">
    <div class="dialog [size-sm|size-md|size-lg]">
        <div class="dialog-header">
            <h2 class="dialog-title">对话框标题</h2>
            <button class="dialog-close">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="dialog-content">
            <!-- 内容区域 -->
        </div>
        <div class="dialog-footer">
            <button class="button secondary">取消</button>
            <button class="button primary">确认</button>
        </div>
    </div>
</div>
```

**尺寸**：

| 尺寸 | 类名 | 宽度 | 使用场景 |
|------|------|------|---------|
| **小** | `.size-sm` | 400px | 确认对话框 |
| **标准** | - | 560px | 表单对话框 |
| **大** | `.size-lg` | 800px | 复杂配置 |

**使用规则**：
- ✅ 对话框必须有关闭按钮（右上角 ×）
- ✅ 点击遮罩层（overlay）可关闭对话框
- ✅ 对话框打开时，body 必须锁定滚动
- ❌ 禁止对话框嵌套对话框

---

#### 2.2.4 导航栏 (Navbar / Sidebar)

**侧边栏结构**：
```html
<nav class="sidebar">
    <div class="sidebar-header">
        <!-- Logo + 标题 -->
    </div>
    <div class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-section-title">分组标题</div>
            <a class="nav-item [active]" href="#">
                <i class="nav-icon"></i>
                <span>导航项</span>
            </a>
        </div>
    </div>
    <div class="sidebar-footer">
        <!-- 用户信息 -->
    </div>
</nav>
```

**使用规则**：
- ✅ 导航项高度 40px，间距 2px
- ✅ 激活状态：左侧 3px 蓝色边框 + 浅蓝背景
- ✅ 图标尺寸 20px，与文本间距 12px
- ❌ 禁止在侧边栏使用超过 2 个分组

---

### 2.3 业务组件

#### 2.3.1 统计卡片 (Stat Card)

**组件结构**：
```html
<div class="stat-card">
    <div class="stat-icon [blue|green|orange|purple]">
        <i class="fas fa-icon"></i>
    </div>
    <div class="stat-content">
        <div class="stat-value">1,247</div>
        <div class="stat-label">已迁移文件</div>
    </div>
    <div class="stat-trend [up|down]">
        <i class="fas fa-arrow-up"></i>
        <span>12%</span>
    </div>
</div>
```

**使用规则**：
- ✅ 统计值字号 24px、字重 700
- ✅ 趋势指示器必须使用箭头 + 百分比
- ✅ 图标容器尺寸 48px × 48px

---

#### 2.3.2 进度条 (Progress Bar)

**组件结构**：
```html
<div class="progress-bar">
    <div class="progress-fill [green|orange|red]" style="width: 78%"></div>
</div>
```

**状态颜色**：
- `< 60%` - 蓝色（默认）
- `60-80%` - 绿色（正常）
- `80-90%` - 橙色（警告）
- `> 90%` - 红色（危险）

---

#### 2.3.3 通知提示 (Notification)

**组件结构**：
```html
<div class="notification [success|warning|error|info]">
    <div class="notification-icon">
        <i class="fas fa-check-circle"></i>
    </div>
    <div class="notification-content">
        <div class="notification-title">标题</div>
        <div class="notification-message">详细消息</div>
    </div>
    <button class="notification-close">
        <i class="fas fa-times"></i>
    </button>
</div>
```

**自动消失时长**：
- `success` - 3000ms
- `info` - 5000ms
- `warning` - 8000ms
- `error` - 不自动消失（必须手动关闭）

---

#### 2.3.4 历史记录列表 (History List)

**组件结构**：
```html
<div class="history-list">
    <div class="history-item">
        <div class="history-icon [success|warning|error]">
            <i class="fas fa-check"></i>
        </div>
        <div class="history-details">
            <div class="history-title">文档文件夹迁移</div>
            <div class="history-meta">2,847 文件 • 1.2 GB • 昨天 14:32</div>
        </div>
        <div class="history-status [success|warning|error]">成功</div>
    </div>
</div>
```

---

### 2.4 组件使用规则

#### 2.4.1 组件命名规范

**BEM 命名规则**：
```
Block__Element--Modifier
```

**示例**：
```css
/* Block */
.card { }

/* Element */
.card__header { }
.card__content { }
.card__footer { }

/* Modifier */
.card--elevated { }
.card__header--bordered { }
```

#### 2.4.2 组件状态管理

**标准状态类**：
- `.is-active` - 激活状态
- `.is-disabled` - 禁用状态
- `.is-loading` - 加载状态
- `.has-error` - 错误状态
- `.is-visible` - 可见状态

#### 2.4.3 组件间距规则

**外间距（Margin）**：
- 组件与组件之间：24px
- 组件内部元素之间：16px
- 相关组件组之间：32px

**内间距（Padding）**：
- 标准组件内边距：16px
- 大组件内边距：24px
- 紧凑型组件内边距：12px

---

## 3. 交互标准

### 3.1 交互模式库

#### 3.1.1 页面切换模式

**模式 A - 淡入淡出（推荐）**：
```css
.page {
    animation: fadeIn 250ms var(--ease-standard);
}
```

**模式 B - 从右侧滑入（向导类）**：
```css
.wizard-step {
    animation: slideInRight 350ms var(--ease-standard);
}
```

**模式 C - 从下方滑入（对话框）**：
```css
.dialog {
    animation: slideUp 250ms var(--ease-standard);
}
```

---

#### 3.1.2 数据加载模式

**模式 A - 骨架屏（推荐）**：
```html
<div class="skeleton">
    <div class="skeleton-line"></div>
    <div class="skeleton-line"></div>
    <div class="skeleton-line w-60"></div>
</div>
```

**模式 B - 旋转加载器**：
```html
<div class="spinner">
    <i class="fas fa-spinner fa-spin"></i>
</div>
```

**模式 C - 进度条**：
```html
<div class="progress-bar">
    <div class="progress-fill" style="width: 60%"></div>
</div>
```

**使用规则**：
- ✅ 加载时间 < 300ms：不显示加载指示器
- ✅ 加载时间 300ms-1s：显示旋转加载器
- ✅ 加载时间 > 1s：显示骨架屏或进度条

---

#### 3.1.3 操作确认模式

**模式 A - 内联确认（推荐）**：
```javascript
// 点击删除按钮后，按钮变为"确认删除"
button.textContent = '确认删除';
button.classList.add('danger');
setTimeout(() => {
    button.textContent = '删除';
    button.classList.remove('danger');
}, 3000);
```

**模式 B - 对话框确认**：
```javascript
if (confirm('确定要删除吗？此操作不可撤销。')) {
    // 执行删除
}
```

**使用规则**：
- ✅ 危险操作（删除、重置）必须确认
- ✅ 普通操作（保存、提交）可直接执行
- ❌ 禁止堆叠超过 2 个确认对话框

---

### 3.2 交互反馈规范

#### 3.2.1 悬停反馈（Hover）

**标准反馈**：
- 颜色变化：150ms
- 阴影变化：250ms
- 位移变化：250ms

**示例**：
```css
.button {
    transition: all 150ms var(--ease-standard);
}

.button:hover {
    background: var(--primary-hover);
    box-shadow: var(--shadow-md);
    transform: translateY(-1px);
}
```

---

#### 3.2.2 点击反馈（Active）

**标准反馈**：
- 缩放：0.98
- 颜色加深：20%

**示例**：
```css
.button:active {
    transform: scale(0.98);
    background: var(--primary-active);
}
```

---

#### 3.2.3 焦点反馈（Focus）

**标准反馈**：
- 外部轮廓：3px 半透明主色
- 轮廓偏移：2px

**示例**：
```css
.button:focus {
    outline: none;
    box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
}
```

---

#### 3.2.4 加载反馈（Loading）

**按钮加载状态**：
```html
<button class="button primary is-loading">
    <i class="fas fa-spinner fa-spin"></i>
    <span>处理中...</span>
</button>
```

**使用规则**：
- ✅ 加载时按钮必须禁用
- ✅ 必须显示加载指示器（ spinner 或进度条）
- ✅ 加载文本必须明确（"处理中..." 而非 "加载中..."）

---

### 3.3 错误处理规范

#### 3.3.1 错误类型与处理方式

| 错误类型 | 严重程度 | 处理方式 | 示例 |
|---------|---------|---------|------|
| **网络错误** | 中 | 顶部通知栏 + 重试按钮 | "网络连接失败，请检查网络" |
| **权限错误** | 高 | 对话框 + 跳转登录 | "会话已过期，请重新登录" |
| **验证错误** | 低 | 输入框下方红色文本 | "密码必须包含至少 8 个字符" |
| **服务器错误** | 高 | 全页错误界面 + 联系支持 | "500 内部服务器错误" |
| **操作失败** | 中 | Toast 通知 + 回滚操作 | "文件移动失败，已恢复原状" |

---

#### 3.3.2 错误提示文案规范

**标准格式**：
```
[问题描述]。[建议操作]。
```

**示例**：
- ✅ "网络连接失败。请检查网络后重试。"
- ✅ "密码错误。请重新输入或点击"忘记密码"。"
- ❌ "Error 500"（不友好）
- ❌ "出错了"（无建议）

---

#### 3.3.3 表单验证错误规范

**实时验证（推荐）**：
- 用户输入时：不显示错误
- 用户离开输入框时：显示错误（如果有的话）
- 用户提交表单时：显示所有错误

**错误文本规范**：
- 颜色：Danger (`#C4314B`)
- 字号：12px
- 位置：输入框正下方
- 图标：⚠️ （可选）

**示例**：
```html
<div class="form-group has-error">
    <label class="form-label">邮箱</label>
    <input type="email" class="form-input is-invalid">
    <span class="form-error">
        <i class="fas fa-exclamation-circle"></i>
        请输入有效的邮箱地址
    </span>
</div>
```

---

#### 3.3.4 空状态错误规范

**404 页面**：
```html
<div class="empty-state">
    <i class="fas fa-search"></i>
    <h3>页面未找到</h3>
    <p>您访问的页面可能已被移动或删除</p>
    <button class="button primary" onclick="goBack()">返回上一页</button>
</div>
```

**无权限页面**：
```html
<div class="empty-state">
    <i class="fas fa-lock"></i>
    <h3>访问被拒绝</h3>
    <p>您没有权限访问此页面</p>
    <button class="button primary" onclick="goToHome()">返回首页</button>
</div>
```

---

### 3.4 空状态设计规范

#### 3.4.1 空状态类型

| 类型 | 图标 | 标题 | 描述 | 操作 |
|------|------|------|------|------|
| **无数据** | 📭 | "暂无数据" | "当前没有可显示的内容" | [创建] 按钮 |
| **搜索无结果** | 🔍 | "未找到结果" | "尝试使用不同的关键词搜索" | [清除搜索] 按钮 |
| **无权限** | 🔒 | "访问被拒绝" | "您没有权限查看此内容" | [申请权限] 按钮 |
| **页面不存在** | 🚫 | "页面未找到" | "您访问的页面可能已被移动" | [返回] 按钮 |
| **网络错误** | 🌐 | "连接失败" | "请检查网络连接" | [重试] 按钮 |

---

#### 3.4.2 空状态组件结构

```html
<div class="empty-state">
    <div class="empty-state-icon">
        <i class="fas fa-inbox"></i>
    </div>
    <h3 class="empty-state-title">暂无迁移记录</h3>
    <p class="empty-state-description">
        您还没有进行任何迁移操作，点击下方按钮开始第一次迁移。
    </p>
    <div class="empty-state-actions">
        <button class="button primary">
            <i class="fas fa-plus"></i>
            <span>开始迁移</span>
        </button>
        <button class="button">
            <i class="fas fa-question-circle"></i>
            <span>查看教程</span>
        </button>
    </div>
</div>
```

---

#### 3.4.3 空状态设计规则

**图标规范**：
- 尺寸：48px × 48px
- 颜色：Gray 400
- 风格：线性图标（2px 描边）

**文本规范**：
- 标题：16px、字重 600、Gray 900
- 描述：14px、字重 400、Gray 500、最大 2 行

**按钮规范**：
- 主要操作：1 个主要按钮
- 次要操作：最多 1 个次要按钮
- 禁止：空状态下超过 2 个操作按钮

---

#### 3.4.4 空状态使用示例

**示例 1 - 无迁移历史**：
```html
<div class="empty-state">
    <i class="fas fa-history"></i>
    <h3>暂无迁移记录</h3>
    <p>您还没有进行任何迁移操作</p>
    <button class="button primary" onclick="navigateToPage('migrate')">
        <i class="fas fa-plus"></i>
        <span>开始迁移</span>
    </button>
</div>
```

**示例 2 - 搜索无结果**：
```html
<div class="empty-state">
    <i class="fas fa-search"></i>
    <h3>未找到匹配项</h3>
    <p>没有与"{{keyword}}"匹配的迁移记录</p>
    <button class="button" onclick="clearSearch()">
        <i class="fas fa-times"></i>
        <span>清除搜索</span>
    </button>
</div>
```

---

## 4. 附录：设计规范检查清单

### 4.1 设计评审检查清单

**色彩**：
- [ ] 主色使用正确（Primary #0066CC）
- [ ] 功能色与语义匹配
- [ ] 对比度 ≥ 4.5:1

**字体**：
- [ ] 字体族正确（Inter / Microsoft YaHei）
- [ ] 字号符合规范（正文 14px）
- [ ] 字重使用正确

**间距**：
- [ ] 使用 4px 基准间距系统
- [ ] 组件间距统一（24px）
- [ ] 内边距符合规范（16px / 24px）

**组件**：
- [ ] 组件命名符合 BEM 规范
- [ ] 组件状态完整（hover/active/focus/disabled）
- [ ] 组件复用率高（避免重复代码）

**交互**：
- [ ] 动画时长符合规范（150ms/250ms/350ms）
- [ ] 缓动函数统一（cubic-bezier(0.4, 0, 0.2, 1)）
- [ ] 反馈及时（< 100ms）

**响应式**：
- [ ] 桌面端布局正确（≥ 1024px）
- [ ] 平板端布局正确（768px - 1023px）
- [ ] 移动端布局正确（< 768px）

---

### 4.2 开发实现检查清单

**HTML**：
- [ ] 语义化标签（header/nav/main/section）
- [ ] 可访问性属性（aria-label/role）
- [ ] 图片有 alt 属性

**CSS**：
- [ ] 使用 CSS 变量（:root）
- [ ] 避免 !important
- [ ] 移动端使用媒体查询

**JavaScript**：
- [ ] 事件委托（避免过多监听器）
- [ ] 防抖/节流（滚动/输入事件）
- [ ] 错误处理（try-catch）

---

### 4.3 性能优化检查清单

**加载性能**：
- [ ] 图片懒加载（loading="lazy"）
- [ ] 代码分割（按需加载）
- [ ] 资源压缩（Gzip/Brotli）

**渲染性能**：
- [ ] 避免强制同步布局（layout thrashing）
- [ ] 使用 CSS 硬件加速（transform/opacity）
- [ ] 减少重绘和回流

**动画性能**：
- [ ] 使用 transform 和 opacity（避免 top/left）
- [ ] 使用 requestAnimationFrame
- [ ] 避免动画卡顿（< 16ms/frame）

---

## 📚 参考资料

- **Windows Fluent Design**: https://fluent2.microsoft.design/
- **WCAG 2.1 无障碍指南**: https://www.w3.org/WAI/WCAG21/quickref/
- **Inter 字体**: https://fonts.google.com/specimen/Inter
- **Font Awesome 图标**: https://fontawesome.com/icons

---

**文档版本历史**：

| 版本 | 日期 | 作者 | 变更内容 |
|------|------|------|---------|
| v1.0.0 | 2026-06-26 | WorkBuddy | 初始版本 |

---

** END OF DOCUMENT **

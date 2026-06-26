# DESIGN.md — Windows 用户文件迁移工具设计系统

> 设计系统架构师: Diana  
> 参考品牌: Microsoft Windows 11 Fluent Design System  
> 生成时间: 2026-06-26  
> 项目: Windows 用户文件迁移工具

---

## 1. Visual Theme & Atmosphere（视觉主题与氛围）

**品牌设计哲学**: Windows 11 Fluent Design 系统强调自然交互、深度层次和材质真实感。本应用继承这一哲学，为系统工具提供现代化、可信赖的视觉体验。

**视觉基调**: 专业、高效、安静

**5 个核心视觉特征关键词**:
- **Mica 半透明** — 背景模糊效果，层次感
- **圆角柔和** — 12px 大圆角，友好亲和
- **深度阴影** — 三层阴影系统，空间感
- **动态反馈** — 涟漪效果、平滑过渡
- **极简克制** — 留白充足，信息聚焦

**光影与质感倾向**: 毛玻璃效果（backdrop-filter: blur）+ 微阴影 + 半透明表面

---

## 2. Color Palette & Roles（调色板与角色）

### Primary Colors（主色）

| 角色 | HEX | CSS 变量 | 使用场景 |
|------|-----|-----------|----------|
| Primary | `#0066CC` | `--primary-color` | 主要按钮、活跃状态、链接 |
| Primary Hover | `#0052A3` | `--primary-hover` | 主色悬停状态 |
| Primary Active | `#003D7A` | `--primary-active` | 主色按下状态 |
| Primary Light | `rgba(0, 102, 204, 0.1)` | `--primary-light` | 主色背景淡色 |

### Brand & Dark（品牌色与深色）

| 角色 | HEX | CSS 变量 | 使用场景 |
|------|-----|-----------|----------|
| Brand Blue | `#0066CC` | `--brand-blue` | 品牌主色 |
| Brand Dark | `#003D7A` | `--brand-dark` | 深色变体 |

### Accent / Interactive（强调色与交互色）

| 角色 | HEX | CSS 变量 | 使用场景 |
|------|-----|-----------|----------|
| Accent | `#8764B8` | `--accent-color` | 强调元素（可选） |

### Neutral / Gray Scale（中性灰阶系统）

| 角色 | HEX | CSS 变量 | 使用场景 |
|------|-----|-----------|----------|
| Gray 0 (White) | `#FFFFFF` | `--gray-0` | 纯白背景 |
| Gray 10 | `#F9F9F9` | `--gray-10` | 页面背景 |
| Gray 20 | `#F0F0F0` | `--gray-20` | 卡片背景 |
| Gray 30 | `#E7E7E7` | `--gray-30` | 悬停背景 |
| Gray 40 | `#CECECE` | `--gray-40` | 边框、分割线 |
| Gray 50 | `#B4B4B4` | `--gray-50` | 禁用状态 |
| Gray 60 | `#9A9A9A` | `--gray-60` | 图标、辅助文本 |
| Gray 70 | `#808080` | `--gray-70` | 次要文本 |
| Gray 80 | `#666666` | `--gray-80` | 正文文本 |
| Gray 90 | `#4D4D4D` | `--gray-90` | 标题文本 |
| Gray 100 (Black) | `#333333` | `--gray-100` | 主要文本 |

### Surface & Borders（表面与边框色）

| 角色 | HEX | CSS 变量 | 使用场景 |
|------|-----|-----------|----------|
| Surface | `rgba(255, 255, 255, 0.8)` | `--surface` | 卡片、对话框表面 |
| Surface Strong | `rgba(255, 255, 255, 0.95)` | `--surface-strong` | 对话框、弹出层 |
| Border | `rgba(0, 0, 0, 0.05)` | `--border` | 默认边框 |
| Border Strong | `rgba(0, 0, 0, 0.12)` | `--border-strong` | 强烈边框 |

### Semantic Colors（语义色）

| 角色 | HEX | CSS 变量 | 使用场景 |
|------|-----|-----------|----------|
| Success | `#0D6832` | `--success-color` | 成功状态、完成操作 |
| Success Light | `rgba(13, 104, 50, 0.1)` | `--success-light` | 成功背景淡色 |
| Warning | `#8A5700` | `--warning-color` | 警告状态、需要注意 |
| Warning Light | `rgba(138, 87, 0, 0.1)` | `--warning-light` | 警告背景淡色 |
| Danger | `#C4314B` | `--danger-color` | 错误、危险操作 |
| Danger Light | `rgba(196, 49, 75, 0.1)` | `--danger-light` | 错误背景淡色 |
| Info | `#0066CC` | `--info-color` | 信息提示 |
| Info Light | `rgba(0, 102, 204, 0.1)` | `--info-light` | 信息背景淡色 |

### Shadow Colors（阴影色）

| 角色 | RGBA | CSS 变量 | 使用场景 |
|------|-------|-----------|----------|
| Shadow Small | `rgba(0, 0, 0, 0.05)` | `--shadow-small-color` | 小阴影 |
| Shadow Medium | `rgba(0, 0, 0, 0.1)` | `--shadow-medium-color` | 中等阴影 |
| Shadow Large | `rgba(0, 0, 0, 0.15)` | `--shadow-large-color` | 大阴影 |

---

## 3. Typography Rules（排版规则）

### Font Family（字体族）

```
Segoe UI Variable, Segoe UI, -apple-system, BlinkMacSystemFont, sans-serif
```

**设计哲学**: Windows 11 原生字体，优化屏幕显示效果，支持可变字体技术。

### Type Scale（排版层级表）

| 层级 | Font Size | Font Weight | Line Height | Letter Spacing | 使用场景 |
|------|-----------|--------------|--------------|-----------------|----------|
| Display Hero | 28px | 600 | 36px | -0.5px | 欢迎标题 |
| Title | 20px | 600 | 28px | 0px | 页面标题 |
| Subtitle | 16px | 600 | 24px | 0px | 区块标题 |
| Body | 14px | 400 | 20px | 0px | 正文文本 |
| Caption | 12px | 400 | 16px | 0.2px | 辅助文本、标签 |
| Small | 11px | 400 | 16px | 0.3px | 状态栏、小字 |

**字重系统**:
- 300 — Light（预留）
- 400 — Regular（正文）
- 500 — Medium（导航项）
- 600 — Semibold（标题）
- 700 — Bold（预留）

**行高规则**:
- 标题类: 1.4 × font-size
- 正文类: 1.5 × font-size
- 辅助文本: 1.3 × font-size

---

## 4. Component Stylings（组件样式）

### Buttons（按钮）

#### Primary Button（主要按钮）

```css
.win11-button.primary {
    background: var(--primary-color);
    color: white;
    border: 1px solid var(--primary-color);
    border-radius: 8px;
    padding: 8px 16px;
    font-size: 14px;
    font-weight: 400;
    cursor: pointer;
    transition: all 0.15s ease;
}

.win11-button.primary:hover {
    background: var(--primary-hover);
    border-color: var(--primary-hover);
}

.win11-button.primary:active {
    background: var(--primary-active);
    border-color: var(--primary-active);
    transform: scale(0.98);
}
```

#### Secondary Button（次要按钮）

```css
.win11-button {
    background: rgba(255, 255, 255, 0.8);
    color: var(--gray-100);
    border: 1px solid var(--border-strong);
    border-radius: 8px;
    padding: 8px 16px;
    font-size: 14px;
    font-weight: 400;
    cursor: pointer;
    transition: all 0.15s ease;
}

.win11-button:hover {
    background: rgba(255, 255, 255, 0.9);
    border-color: rgba(0, 0, 0, 0.2);
}
```

### Cards（卡片）

```css
.status-card,
.quick-action-card {
    background: var(--surface);
    backdrop-filter: blur(10px);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 16px;
    box-shadow: 0 2px 4px var(--shadow-small-color);
    transition: all 0.2s ease;
}

.status-card:hover,
.quick-action-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px var(--shadow-medium-color);
    border-color: rgba(0, 102, 204, 0.3);
}
```

### Inputs（输入框）

```css
.win11-input {
    background: rgba(255, 255, 255, 0.8);
    border: 1px solid var(--border-strong);
    border-radius: 8px;
    padding: 8px 12px;
    font-size: 14px;
    font-family: var(--font-family);
    transition: all 0.15s ease;
}

.win11-input:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 2px rgba(0, 102, 204, 0.2);
}

.win11-input::placeholder {
    color: var(--gray-60);
}
```

### Navigation（导航）

```css
.nav-item {
    display: flex;
    align-items: center;
    padding: 8px 12px;
    margin-bottom: 2px;
    border-radius: 8px;
    color: var(--gray-80);
    transition: all 0.15s ease;
}

.nav-item:hover {
    background: rgba(0, 0, 0, 0.05);
    color: var(--gray-100);
}

.nav-item.active {
    background: var(--primary-color);
    color: white;
}
```

### Dialogs / Modals（对话框）

```css
.dialog {
    background: var(--surface-strong);
    backdrop-filter: blur(40px);
    border-radius: 12px;
    box-shadow: 0 8px 16px var(--shadow-large-color), 0 0 0 1px var(--border);
    min-width: 400px;
    max-width: 500px;
    animation: dialogOpen 0.2s ease-out;
}

.dialog-overlay {
    background: rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(4px);
}
```

---

## 5. Layout Principles（布局原则）

### Spacing System（间距系统）

**基准单位**: 4px

| Token | 值 | 使用场景 |
|-------|-----|----------|
| `--spacing-xs` | 4px | 最小间距 |
| `--spacing-sm` | 8px | 紧凑间距 |
| `--spacing-md` | 12px | 标准间距 |
| `--spacing-lg` | 16px | 中等间距 |
| `--spacing-xl` | 24px | 大间距 |
| `--spacing-xxl` | 32px | 超大间距 |

### Grid System（网格系统）

- **列数**: 自适应（auto-fit）
- **列间距**: 16px
- **行间距**: 16px
- **最大宽度**: 1400px（窗口）

### Container（容器）

- **页面内边距**: 24px（桌面端），16px（移动端）
- **卡片内边距**: 16px
- **对话框内边距**: 24px

### Section Spacing（区块间距）

- **区块之间**: 32px
- **区块内部**: 16px

**留白哲学**: 充足留白让内容呼吸，避免信息过载。Fluent Design 强调"空气感"，通过留白创造层次。

---

## 6. Depth & Elevation（深度与层级）

### Shadow System（阴影系统）

| Token | box-shadow CSS 值 | 使用场景 |
|-------|---------------------|----------|
| `--shadow-xs` | `0 1px 2px rgba(0, 0, 0, 0.05)` | 卡片悬停（轻微） |
| `--shadow-small` | `0 2px 4px rgba(0, 0, 0, 0.05)` | 卡片默认 |
| `--shadow-medium` | `0 4px 8px rgba(0, 0, 0, 0.1)` | 卡片悬停、下拉菜单 |
| `--shadow-large` | `0 8px 16px rgba(0, 0, 0, 0.15)` | 对话框、弹出层 |
| `--shadow-xlarge` | `0 16px 32px rgba(0, 0, 0, 0.2)` | 命令栏（预留） |

### Surface Layers（表面层级）

| 层级 | 背景 | 模糊效果 | Z-index |
|------|------|-----------|---------|
| Background | `#F9F9F9` | 无 | 0 |
| Surface | `rgba(255, 255, 255, 0.8)` | `blur(10px)` | 1 |
| Elevated | `rgba(255, 255, 255, 0.9)` | `blur(20px)` | 10 |
| Overlay | `rgba(255, 255, 255, 0.95)` | `blur(40px)` | 100 |
| Dialog | `rgba(0, 0, 0, 0.3)` 遮罩 | `blur(4px)` | 1000 |

### Z-index Scale（层级数值规范）

```css
.navigation-pane { z-index: 10; }
.content-area { z-index: 1; }
.dialog-overlay { z-index: 1000; }
.notification { z-index: 2000; }
```

### Backdrop Effects（背景效果）

```css
/* Mica 效果 */
.mica {
    background: rgba(249, 249, 249, 0.85);
    backdrop-filter: blur(40px);
    -webkit-backdrop-filter: blur(40px);
}

/* 亚克力效果（更强模糊） */
.acrylic {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(60px);
    -webkit-backdrop-filter: blur(60px);
}
```

---

## 7. Do's and Don'ts（设计规范与禁忌）

### Do's（推荐实践）

1. **使用 Mica 半透明效果** — 增强层次感和现代感
2. **保持 8px 圆角一致性** — 所有可点击元素统一圆角
3. **使用 4px 基准间距系统** — 保持视觉节奏一致
4. **提供即时视觉反馈** — 悬停、点击、焦点状态必须明确
5. **使用语义色彩** — 成功/警告/错误状态用对应色彩
6. **保持留白充足** — 避免信息过载，让内容呼吸
7. **使用系统字体 Segoe UI Variable** — 确保原生 Windows 体验
8. **动画时长保持 0.15-0.3s** — 快速响应，不拖沓

### Don'ts（应避免的反模式）

1. **不要使用锐利直角** — 所有元素应有圆角（至少 4px）
2. **不要使用纯黑纯白** — 文本用 `#333333`，背景用 `#F9F9F9`
3. **不要过度使用阴影** — 阴影用于层次，不是装饰
4. **不要使用非系统字体** — 避免安装额外字体依赖
5. **不要忽略焦点状态** — 键盘导航用户需要明确焦点指示
6. **不要使用过于鲜艳的色彩** — Windows 风格是克制和专业的
7. **不要忽略响应式** — 移动端导航应自动折叠
8. **不要使用闪烁动画** — 避免引发光敏性癫痫

---

## 8. Responsive Behavior（响应式行为）

### Breakpoints（断点定义）

| 断点 | 宽度 | 设备类型 |
|------|------|----------|
| Mobile | < 768px | 手机 |
| Tablet | 768px - 1200px | 平板 |
| Desktop | > 1200px | 桌面 |
| Wide | > 1920px | 大屏（预留） |

### Touch Targets（触摸目标）

- **最小触摸目标**: 44px × 44px
- **按钮高度**: 32px（鼠标），44px（触摸）
- **导航项高度**: 36px

### 折叠策略

#### 移动端 (< 768px)

```css
@media (max-width: 768px) {
    /* 导航Pane 折叠为图标模式 */
    .navigation-pane {
        width: 68px;
    }
    
    .nav-header,
    .nav-title,
    .nav-item span,
    .nav-section-title,
    .nav-footer-info span {
        display: none;
    }
    
    /* 欢迎横幅改为垂直布局 */
    .welcome-banner {
        flex-direction: column;
        text-align: center;
    }
    
    /* 状态卡片改为单列 */
    .status-cards {
        grid-template-columns: 1fr;
    }
}
```

### Font Scaling（字体缩放策略）

- **桌面端**: 保持默认尺寸（14px body）
- **移动端**: 保持默认尺寸（Windows 应用通常不缩放字体）
- **高 DPI**: 依赖 Windows 系统 DPI 缩放

---

## 9. Agent Prompt Guide（AI 代理提示指南）

### Quick Reference（快速参考）

```css
/* 核心 CSS 变量 */
:root {
    --primary-color: #0066CC;
    --success-color: #0D6832;
    --warning-color: #8A5700;
    --danger-color: #C4314B;
    --gray-100: #333333;
    --gray-10: #F9F9F9;
    --radius-medium: 8px;
    --spacing-md: 12px;
    --font-family: 'Segoe UI Variable', 'Segoe UI', sans-serif;
}
```

### Component Prompts（组件生成 Prompt 示例）

#### Prompt 1: 生成 Windows 11 风格按钮

```
使用 Windows 11 Fluent Design 风格创建一个按钮组件：
- 主色: #0066CC
- 圆角: 8px
- 背景: 半透明（rgba(255, 255, 255, 0.8)）
- 悬停: 背景变深，边框颜色加深
- 按下: 缩放 0.98
- 字体: Segoe UI Variable, 14px
- 过渡动画: 0.15s ease
```

#### Prompt 2: 生成卡片组件

```
创建一个 Windows 11 风格卡片：
- 背景: 半透明 + backdrop-filter: blur(10px)
- 边框: 1px solid rgba(0, 0, 0, 0.05)
- 圆角: 8px
- 阴影: 0 2px 4px rgba(0, 0, 0, 0.05)
- 悬停效果: 上移 2px + 阴影加深 + 边框变蓝
- 内边距: 16px
```

#### Prompt 3: 生成导航项

```
创建左侧导航项组件：
- 高度: 36px
- 圆角: 8px
- 内边距: 8px 12px
- 非活跃: 透明背景，灰色文字
- 悬停: 浅灰背景（rgba(0, 0, 0, 0.05)）
- 活跃: 蓝色背景（#0066CC），白色文字
- 图标: 20px 宽，居中对齐
```

### Iteration Guide（AI 生成 UI 迭代建议）

1. **首次生成** — 使用上述 Prompt 生成基础组件
2. **调整圆角** — 如果感觉太圆，减小到 6px；如果太锐，增大到 12px
3. **调整阴影** — 如果感觉太平，增加阴影强度；如果太重，减小或移除
4. **调整间距** — 如果感觉太挤，增大 spacing 值；如果太松，减小
5. **调整色彩** — 如果感觉太鲜艳，降低饱和度；如果太暗，提高亮度
6. **添加动画** — 如果感觉太死板，添加悬停过渡和点击反馈
7. **测试响应式** — 在不同宽度下检查布局是否自然折叠
8. **测试可访问性** — 确保对比度足够，焦点状态明确

---

**文档版本**: 1.0  
**最后更新**: 2026-06-26  
**维护者**: DesignMdArchitect (Diana)

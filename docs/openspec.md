# OpenSpec — Windows-User-Files-Mover 项目规范文档

**文档版本：** 1.1.0  
**对应项目版本：** v1.12.0  
**作者：** SutChan  
**最后更新：** 2026-06-26  
**项目地址：** https://github.com/sutchan/Windows-User-Files-Mover  

---

## 目录

1. [项目概述](#1-项目概述)
2. [架构设计](#2-架构设计)
3. [文件结构规范](#3-文件结构规范)
4. [功能模块规范](#4-功能模块规范)
5. [编码规范](#5-编码规范)
6. [错误处理规范](#6-错误处理规范)
7. [日志规范](#7-日志规范)
8. [版本管理规范](#8-版本管理规范)
9. [文档规范](#9-文档规范)
10. [测试规范](#10-测试规范)
11. [发布规范](#11-发布规范)
12. [贡献规范](#12-贡献规范)

---

## 1. 项目概述

### 1.1 项目定位

Windows-User-Files-Mover 是一款面向 Windows 系统的**用户文件迁移与开始菜单管理工具**，核心目标是：

- 将用户文件夹（Documents、Downloads、Pictures 等）安全地迁移到非系统盘；
- 将开发工具配置目录（`.vscode`、`.cursor` 等）迁移到非系统盘并保持路径兼容；
- 提供开始菜单布局、文件夹、数据库的备份与还原能力；
- 通过 NTFS Junction Points（目录联接）确保应用程序路径透明，无需修改任何配置。

### 1.2 目标用户

| 用户类型 | 使用版本 | 典型场景 |
|----------|----------|----------|
| 普通用户 | Python GUI 版 / EXE 版 | 图形界面操作，迁移桌面、文档、下载等文件夹 |
| 系统管理员 | 批处理版 | 命令行批量迁移，脚本集成，服务器环境 |
| 开发者 | PowerShell 版 / 开发配置迁移 GUI 版 | 迁移 `.vscode`、`.cursor`、`.workbuddy` 等开发配置目录 |
| UI/UX 设计师 | HTML 原型版 | 查看 Windows 11 风格 UI 设计，评审用户体验 |
| 最终用户 | Windows 桌面应用版 | 使用现代化 CustomTkinter GUI 进行文件迁移 |

### 1.3 核心约束

- **必须以管理员身份运行**（创建目录联接需要）；
- **不修改注册表**，仅依赖文件系统 Junction Point；
- **操作幂等**：重复执行不应导致数据损坏；
- **向后兼容**：迁移后的路径对所有已安装应用透明；
- **跨语言系统支持**：不依赖本地化字符串做路径判断（v1.12.0+ 已使用 WMIC 替代 `dir`）。

---

## 2. 架构设计

### 2.1 整体架构

```
┌──────────────────────────────────────────────────────┐
│                  用户交互层 (UI Layer)                 │
│   Python GUI (tkinter)   │   Batch CLI   │   PS CLI   │
├──────────────────────────────────────────────────────┤
│                  业务逻辑层 (Logic Layer)              │
│   文件迁移   │   开始菜单备份   │   开始菜单还原        │
├──────────────────────────────────────────────────────┤
│                  系统调用层 (System Layer)             │
│   ROBOCOPY   │   mklink /J   │   PowerShell   │ WMI  │
└──────────────────────────────────────────────────────┘
```

### 2.2 版本矩阵

| 版本 | 文件 | UI 类型 | 依赖 | 适用场景 |
|------|------|---------|------|----------|
| 批处理版 | `Windows_UserFiles_Mover.bat` | 命令行 TUI | 无（Windows 内置） | 快速迁移、脚本集成 |
| Python GUI 版 | `Windows_UserFiles_Mover.py` | tkinter GUI | Python 3.6+ | 交互式操作 |
| EXE 版 | `dist/Windows_UserFiles_Mover.exe` | tkinter GUI | 无（PyInstaller 打包） | 无 Python 环境的机器 |
| PowerShell 版 | `Move-DevConfigs.ps1` | 命令行 | PowerShell 5.1+，管理员 | 开发配置目录专用迁移 |
| 开发配置迁移 GUI 版 | `Move_DevConfigs_GUI.py` / `dist/Move_DevConfigs_GUI.exe` | tkinter GUI | Python 3.6+ / 无依赖（EXE） | 开发者 GUI 迁移 AI/IDE 配置 |
| Windows 桌面应用版 | `Windows_Migration_App.py` | CustomTkinter GUI | Python 3.6+，CustomTkinter | 现代化 UI、更好用户体验 |
| HTML 原型版 | `prototype/windows-app/index.html` | Web 页面（静态） | 现代浏览器 | 设计展示、UI/UX 评审、用户测试 |

### 2.3 核心技术

- **ROBOCOPY**：用于文件夹复制，参数 `/E /COPYALL /ZB /R:3 /W:5` 保证完整性与容错性；
- **mklink /J**：创建 NTFS 目录联接，对应用程序路径透明；
- **WMIC**：跨语言查询磁盘空间（替代 `dir`，兼容非中文系统）；
- **tkinter**：Python GUI 框架，无需额外安装；
- **threading**：Python 版异步执行耗时操作，保持 UI 响应。

---

## 3. 文件结构规范

### 3.1 目录布局（规范）

```
Windows-User-Files-Mover/
├── Windows_UserFiles_Mover.bat       # 批处理版主程序
├── Windows_UserFiles_Mover.py        # Python GUI 版主程序
├── Move-DevConfigs.ps1               # PowerShell 版（开发配置专用）
├── README.md                         # 项目说明（面向用户）
├── TODO.md                           # 待办事项
├── VERSION_HISTORY.md                # 版本历史
├── LICENSE                           # MIT 许可证
├── Windows-User-Files-Mover.code-workspace  # VSCode 工作区配置
└── docs/
    ├── openspec.md                   # 本文件：项目规范文档
    ├── user_guide.md                 # 用户指南
    ├── installation_guide.md         # 安装指南
    ├── api_reference.md              # API 参考
    ├── faq.md                        # 常见问题
    └── optimization_suggestions.md  # 优化建议
```

### 3.2 文件命名规范

| 类型 | 命名格式 | 示例 |
|------|----------|------|
| Python 脚本 | `PascalCase_With_Underscore.py` | `Windows_UserFiles_Mover.py` |
| 批处理脚本 | `PascalCase_With_Underscore.bat` | `Windows_UserFiles_Mover.bat` |
| PowerShell 脚本 | `Verb-Noun.ps1`（遵循 PS 命名约定） | `Move-DevConfigs.ps1` |
| Markdown 文档 | `snake_case.md` 或中文描述 | `user_guide.md` |
| 日志文件 | `<脚本名>.log` | `Windows_UserFiles_Mover.log` |
| 备份目录 | `StartMenu_Backup_<YYYYMMDD_HHMMSS>` | `StartMenu_Backup_20260626_012345` |

### 3.3 临时文件约定

- 日志文件与主程序同目录，文件名与主程序同名（`.log` 后缀）；
- 不在项目目录内生成临时文件；
- `.gitignore` 需包含 `*.log`、`dist/`、`build/`、`*.spec`、`__pycache__/`。

---

## 4. 功能模块规范

### 4.1 文件迁移模块

#### 4.1.1 迁移流程（规范）

```
1. 权限检查    → 确认管理员身份
2. 参数验证    → 源路径存在？目标盘符有效？
3. 空间检查    → 目标盘剩余空间 ≥ 源文件夹大小 × 1.2
4. 联接检查    → 源路径已是联接？→ 跳过（幂等）
5. ROBOCOPY   → 复制文件，退出码 ≤ 7 视为成功
6. 验证复制    → 抽样校验目标目录
7. 删除源目录  → 复制成功后删除原始目录
8. 创建联接    → mklink /J <source> <target>
9. 联接验证    → 确认联接可访问
10. 日志记录   → 记录成功/失败结果
```

#### 4.1.2 默认迁移目标列表（Python/批处理版）

```
用户文件夹：
  Desktop、Documents、Downloads、Music、Pictures、Videos

应用数据（示例，可配置）：
  AppData\Local\Google
  AppData\Local\Adobe
  AppData\Local\Apple Computer
  AppData\Roaming\...
```

#### 4.1.3 默认迁移目标列表（PowerShell 版）

```powershell
# Move-DevConfigs.ps1 默认迁移的开发配置目录
.codebuddy、.codebuddycn、.codex、.cursor、
.gemini、.lingma、.trae、.trae-aicc、
.trae-cn、.vscode、.workbuddy
```

#### 4.1.4 ROBOCOPY 参数规范

```batch
robocopy <source> <target> /E /COPYALL /ZB /R:3 /W:5 /LOG+:<logfile>
```

| 参数 | 说明 |
|------|------|
| `/E` | 复制所有子目录（含空目录） |
| `/COPYALL` | 复制所有文件属性（数据、属性、时间戳、ACL、所有者、审计信息） |
| `/ZB` | 使用可重启模式，若被拒绝则使用备份模式 |
| `/R:3` | 失败重试 3 次 |
| `/W:5` | 重试等待间隔 5 秒 |
| `/LOG+:` | 追加日志到文件 |

> **退出码约定**：ROBOCOPY 退出码 0–7 均视为成功（部分码表示有警告但文件已复制）；≥8 视为失败，需回滚。

#### 4.1.5 回滚规范

- 发生失败时，**不删除源目录**；
- 若目标目录已部分创建，记录日志但不自动删除（避免数据丢失）；
- 向用户展示明确的错误信息和手动恢复步骤。

### 4.2 开始菜单备份模块

#### 4.2.1 备份内容

| 项目 | 来源路径 | 备份方式 |
|------|----------|----------|
| 布局 XML | `%LOCALAPPDATA%\Microsoft\Windows\Shell\LayoutModification.xml` | 文件复制 |
| 开始菜单文件夹（用户） | `%APPDATA%\Microsoft\Windows\Start Menu` | ROBOCOPY |
| 开始菜单文件夹（系统） | `C:\ProgramData\Microsoft\Windows\Start Menu` | ROBOCOPY |
| 数据库 | `%LOCALAPPDATA%\TileDataLayer\Database` | ROBOCOPY |

#### 4.2.2 备份目录结构

```
<备份目录>/
├── LayoutModification.xml
├── StartMenu_User/          （用户开始菜单文件夹）
├── StartMenu_Common/        （系统公共开始菜单文件夹）
└── TileDataLayer/           （开始菜单数据库，如存在）
```

### 4.3 开始菜单还原模块

#### 4.3.1 还原流程

```
1. 验证备份目录完整性
2. 停止 Explorer 进程（explorer.exe）
3. 还原 TileDataLayer 数据库（如存在备份）
4. 还原开始菜单文件夹（用户 + 系统）
5. 还原 LayoutModification.xml
6. 重启 Explorer 进程
7. 记录日志
```

> Explorer 进程管理：Python 版使用 `subprocess.Popen('explorer.exe')` 重启，避免使用 `os.system('start explorer')` 导致的路径问题。

---

## 5. 编码规范

### 5.1 Python 编码规范

#### 5.1.1 基础约定

- 遵循 **PEP 8**；
- 文件顶部声明 `#!/usr/bin/env python3` 和 `# -*- coding: utf-8 -*-`；
- 字符串统一使用双引号 `"`；
- 缩进：4 个空格（禁止 Tab）；
- 每行最大长度：120 字符（GUI 代码允许适当放宽）。

#### 5.1.2 导入顺序（PEP 8）

```python
# 1. 标准库
import os
import sys
import subprocess
import threading
from datetime import datetime

# 2. 第三方库（如有）
# （目前无第三方依赖）

# 3. 项目内模块（如有）
```

#### 5.1.3 类与方法命名

| 类型 | 命名风格 | 示例 |
|------|----------|------|
| 类名 | `PascalCase` | `WindowsUserFilesMover` |
| 方法名 | `snake_case` | `migrate_folder()` |
| 私有方法 | `_snake_case` | `_run_robocopy()` |
| 常量 | `UPPER_SNAKE_CASE` | `DEFAULT_TARGET_DRIVE` |
| 局部变量 | `snake_case` | `source_path` |

#### 5.1.4 动态获取用户名（强制）

```python
# ✅ 正确
username = os.getlogin()
user_profile = os.path.expanduser("~")

# ❌ 禁止硬编码
username = "Admin"
user_profile = r"C:\Users\Admin"
```

#### 5.1.5 异常处理规范

```python
# ✅ 正确：使用具体异常类型
try:
    shutil.rmtree(source_path)
except PermissionError as e:
    self.log(f"权限不足，无法删除：{source_path} - {e}", level="ERROR")
except OSError as e:
    self.log(f"文件系统错误：{e}", level="ERROR")

# ❌ 禁止裸 except
try:
    ...
except:
    pass
```

### 5.2 批处理编码规范

#### 5.2.1 基础约定

- 文件头部必须包含 `@ECHO off` 和 `SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION`；
- 所有变量引用使用延迟扩展 `!VAR!`（在循环或条件块内）；
- 字符串变量统一用双引号包裹：`SET "VAR=value"`；
- 标签（Label）使用全大写 + 下划线：`:MIGRATE_FOLDER`。

#### 5.2.2 配置集中管理

所有可配置项统一放置在文件顶部的「配置区域」：

```batch
rem 配置区域 - 集中管理所有配置项
SET "CONFIG_VERSION=v1.12.0"
SET "CONFIG_DEFAULT_TARGET_DRIVE=E:"
SET "CONFIG_PROJECT_URL=https://github.com/..."
```

#### 5.2.3 动态获取用户名（强制）

```batch
rem ✅ 正确
SET "USER_NAME=%USERNAME%"
SET "USER_PROFILE=%USERPROFILE%"

rem ❌ 禁止
SET "USER_NAME=Admin"
```

#### 5.2.4 磁盘空间检查

使用 WMIC 替代 `dir`，确保跨语言系统兼容：

```batch
FOR /F "tokens=2 delims==" %%A IN (
    'WMIC LogicalDisk WHERE "DeviceID='%TARGET_DRIVE%'" GET FreeSpace /VALUE 2^>nul'
) DO SET "FREE_SPACE=%%A"
```

### 5.3 PowerShell 编码规范

#### 5.3.1 基础约定

- 脚本顶部必须有 `#Requires -RunAsAdministrator`；
- 使用标准 PowerShell 注释块（`.SYNOPSIS`、`.DESCRIPTION`、`.PARAMETER`、`.EXAMPLE`）；
- 所有参数提供默认值，使用 `$env:USERNAME` 动态获取用户名；
- `$ErrorActionPreference = "Stop"`，强制错误中断。

#### 5.3.2 支持 `-WhatIf`

```powershell
[CmdletBinding(SupportsShouldProcess)]
param(...)

# 在关键操作处检查
if ($PSCmdlet.ShouldProcess($target, "创建目录联接")) {
    cmd /c mklink /J "$source" "$target" | Out-Null
}
```

---

## 6. 错误处理规范

### 6.1 错误分级

| 级别 | 代码/标识 | 含义 | 处理方式 |
|------|-----------|------|----------|
| INFO | `[INFO]` | 正常操作记录 | 记录日志，继续执行 |
| WARN | `[WARN]` | 非致命性问题 | 记录日志，提示用户，继续执行 |
| ERROR | `[ERROR]` | 操作失败 | 记录日志，提示用户，停止当前操作 |
| FATAL | `[FATAL]` | 致命错误 | 记录日志，回滚，退出程序 |

### 6.2 用户权限检查（所有版本必须）

**Python 版：**
```python
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except Exception:
        return False
```

**批处理版：**
```batch
:CHECK_ADMIN
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO [ERROR] 需要管理员权限。
    EXIT /B 1
)
EXIT /B 0
```

### 6.3 参数验证规范

迁移操作前必须验证：

1. 源路径存在且可读；
2. 目标盘符有效且可写；
3. 目标路径不是源路径的子目录（防止循环复制）；
4. 源路径不已经是联接点（幂等检查）；
5. 目标分区文件系统为 NTFS（FAT32/exFAT 不支持 Junction Point）。

---

## 7. 日志规范

### 7.1 日志格式

```
[YYYY-MM-DD HH:MM:SS] [LEVEL] <消息内容>
```

示例：
```
[2026-06-26 01:24:00] [INFO] 开始迁移 Desktop -> E:\Users\Admin\Desktop
[2026-06-26 01:24:05] [INFO] ROBOCOPY 完成，退出码: 1（部分文件已跳过）
[2026-06-26 01:24:05] [INFO] 目录联接创建成功
[2026-06-26 01:24:05] [ERROR] 无法删除源目录：PermissionError
```

### 7.2 日志输出策略

| 版本 | 日志文件 | 日志位置 |
|------|----------|----------|
| Python 版 | `Windows_UserFiles_Mover.log` | 程序同目录 |
| 批处理版 | `Windows_UserFiles_Mover.log` | 程序同目录（`%~dp0` 相对路径） |
| PowerShell 版 | 无文件日志（控制台彩色输出） | 标准输出 |

### 7.3 Python 版日志同步输出

Python 版需同时输出到 UI 文本框和日志文件：

```python
def log(self, message: str, level: str = "INFO"):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{timestamp}] [{level}] {message}"
    # 输出到 UI
    self.log_text.insert(tk.END, line + "\n")
    self.log_text.see(tk.END)
    # 输出到文件
    with open(self.log_file, "a", encoding="utf-8") as f:
        f.write(line + "\n")
```

---

## 8. 版本管理规范

### 8.1 版本号格式

采用**三段式语义版本号**：`主版本号.次版本号.修订号`

| 段 | 触发条件 | 示例 |
|----|----------|------|
| 主版本号 | 不向后兼容的架构变更 | `2.0.0` |
| 次版本号 | 新增向后兼容的功能 | `1.12.0` |
| 修订号 | 问题修复、文档更新 | `1.11.1` |

### 8.2 版本号同步要求

每次发布，以下所有位置的版本号必须同步更新：

- [ ] `Windows_UserFiles_Mover.py` — 文件顶部注释 `版本：vX.Y.Z`
- [ ] `Windows_UserFiles_Mover.py` — UI 标签文字 `版本：vX.Y.Z`
- [ ] `Windows_UserFiles_Mover.bat` — `CONFIG_VERSION=vX.Y.Z`
- [ ] `README.md` — badge 和版本信息章节
- [ ] `VERSION_HISTORY.md` — 新增版本记录

### 8.3 VERSION_HISTORY.md 更新规范

新版本记录格式：

```markdown
### vX.Y.Z (YYYY-MM-DD)

**更新内容：**
- **<变更类别>**：<具体描述>
```

变更类别建议：`新增功能` / `修复问题` / `代码优化` / `文档更新` / `安全修复`

---

## 9. 文档规范

### 9.1 文档清单（必须维护）

| 文档 | 路径 | 目标读者 | 更新频率 |
|------|------|----------|----------|
| 项目说明 | `README.md` | 所有用户 | 每次发布 |
| 项目规范 | `docs/openspec.md` | 贡献者/维护者 | 架构变更时 |
| 用户指南 | `docs/user_guide.md` | 普通用户 | 功能变更时 |
| 安装指南 | `docs/installation_guide.md` | 新用户 | 环境变更时 |
| API 参考 | `docs/api_reference.md` | 开发者 | 接口变更时 |
| 常见问题 | `docs/faq.md` | 用户/支持 | 问题反馈后 |
| 版本历史 | `VERSION_HISTORY.md` | 所有用户 | 每次发布 |
| 待办事项 | `TODO.md` | 贡献者 | 持续更新 |

### 9.2 Markdown 编写规范

- 文档顶部必须包含：文档版本、对应项目版本、最后更新日期；
- 使用标准 Markdown，避免 HTML 标签（`README.md` 的徽章除外）；
- 代码块必须标注语言类型（`` ```python ``、`` ```batch ``、`` ```powershell ``）；
- 链接使用相对路径（跨文档引用）；
- 表格用于对比/列举，正文段落用于解释说明。

### 9.3 中文写作风格

- 中英文之间加空格：`Python 3.6+`，而非 `Python3.6+`；
- 专有名词保持英文大写：`ROBOCOPY`、`NTFS`、`Junction Point`；
- 数字使用阿拉伯数字；
- 中文标点使用全角，代码内使用半角。

---

## 10. 测试规范

### 10.1 测试分类

| 类型 | 说明 | 工具 |
|------|------|------|
| 单元测试 | 核心函数（路径验证、空间计算等）的独立测试 | `pytest` |
| 集成测试 | 完整迁移流程的端到端测试 | 模拟沙箱环境 |
| 兼容性测试 | 不同 Windows 版本（7/10/11）上的验证 | 虚拟机 |
| 回归测试 | 修复后的问题不再复现的验证 | `pytest` |

### 10.2 测试环境要求

- 使用**独立的测试用户目录**，不在真实用户目录下测试；
- 每次测试后**清理联接点和测试文件**；
- 迁移测试需在**独立的测试磁盘分区**（或虚拟盘）上进行；
- 不在生产环境直接运行自动化测试。

### 10.3 手动测试检查清单（每次发布前）

- [ ] 以管理员身份运行批处理版，主菜单正常显示
- [ ] 以普通权限运行时提示权限不足，不崩溃
- [ ] Python 版 GUI 正常启动，三个选项卡均可切换
- [ ] 文件迁移：源目录为联接时跳过（幂等）
- [ ] 文件迁移：目标空间不足时给出明确提示
- [ ] 开始菜单备份后，目录结构完整
- [ ] 开始菜单还原后，Explorer 正常重启
- [ ] PowerShell 版 `-WhatIf` 不执行实际操作
- [ ] 日志文件正确生成并包含时间戳

---

## 11. 发布规范

### 11.1 发布前检查

1. **版本号同步**：所有文件版本号一致（见 [8.2](#82-版本号同步要求)）；
2. **文档更新**：`VERSION_HISTORY.md` 已添加新版本记录；
3. **测试通过**：手动测试检查清单（见 [10.3](#103-手动测试检查清单每次发布前)）全部通过；
4. **代码审查**：无硬编码用户名、无裸 `except`；
5. **日志清理**：提交前不包含 `*.log` 文件。

### 11.2 EXE 打包规范

```batch
rem 使用 PyInstaller 打包
pyinstaller --onefile --windowed ^
    --name "Windows_UserFiles_Mover" ^
    --icon "docs\icon.ico" ^
    Windows_UserFiles_Mover.py
```

- 打包产物存放于 `dist/` 目录；
- `dist/` 目录不提交 Git（已在 `.gitignore`）；
- 每次发布在 GitHub Release 中附上打包的 EXE 文件。

### 11.3 Git 提交规范

提交信息格式：

```
<类型>(<范围>): <简短描述>

[可选正文]

[可选页脚]
```

类型：`feat` / `fix` / `docs` / `refactor` / `test` / `chore`

示例：
```
fix(bat): 使用 WMIC 替代 dir 命令检查磁盘空间

WMIC 支持多语言系统，dir 在非中文环境下解析失败。

Closes #12
```

---

## 12. 贡献规范

### 12.1 开发环境搭建

1. 克隆仓库：`git clone https://github.com/sutchan/Windows-User-Files-Mover.git`
2. 安装 Python 3.6+（勾选 "Add to PATH"）
3. 无需额外依赖，`tkinter` 随 Python 内置
4. 建议使用 VS Code + Python 扩展

### 12.2 提交 Pull Request 流程

1. Fork 项目并创建功能分支：`git checkout -b feat/your-feature`
2. 遵循 [编码规范](#5-编码规范) 进行开发
3. 在 PR 描述中说明变更内容和测试方法
4. 确保版本号已更新（修订号 +1）
5. 确保 `VERSION_HISTORY.md` 已记录变更

### 12.3 Issue 提交规范

提交 Bug 时请包含：
- Windows 版本（例：Windows 11 22H2）
- 使用的工具版本（例：v1.12.0 批处理版）
- 问题复现步骤
- 实际结果 vs 期望结果
- 日志文件内容（如有）

### 12.4 禁止提交的内容

- 硬编码的用户名、路径或机器特定配置
- `*.log` 日志文件
- `dist/`、`build/`、`*.spec` 打包产物
- 测试时生成的临时文件

---

## 附录 A：关键变更记录

| 版本 | 关键规范变更 |
|------|-------------|
| v1.12.0 | 新增 Windows 桌面应用版（CustomTkinter）；新增 HTML 原型版；新增设计系统规范文档；更新所有文件版本号到 v1.12.0 |
| v1.12.0 | 禁止硬编码用户名；强制使用 WMIC 检查磁盘空间；新增 PowerShell 版规范 |
| v1.10.2 | 初建文档体系（用户指南、安装指南、API 参考、FAQ） |
| v1.10.0 | 新增开始菜单数据库备份/还原规范 |
| v1.0.0 | 项目初始化，基础文件迁移规范 |

---

## 附录 B：常用命令速查

```batch
rem 检查目录联接
dir /AL C:\Users\Admin

rem 删除目录联接（不删除目标内容）
rmdir C:\Users\Admin\Desktop

rem 创建目录联接
mklink /J C:\Users\Admin\Desktop E:\Users\Admin\Desktop

rem ROBOCOPY 标准调用
robocopy "C:\Source" "E:\Target" /E /COPYALL /ZB /R:3 /W:5
```

```powershell
# PowerShell：检查路径是否为联接
(Get-Item "C:\Users\Admin\.vscode").LinkType  # "Junction" 表示已是联接

# PowerShell：查询磁盘剩余空间
(Get-PSDrive E).Free / 1GB  # 以 GB 为单位
```

---

*本文档由 SutChan 维护。如发现规范与实际代码不符，以本文档为准并更新代码。*

---

## 13. Windows 桌面应用规范（v1.12.0 新增）

### 13.1 技术栈

- **框架**：Python 3.6+ + CustomTkinter 5.2+
- **文件**：`Windows_Migration_App.py`
- **UI 风格**：Windows 11 Fluent Design（圆角、阴影、Mica 效果）

### 13.2 架构设计

```
┌────────────────────────────────────────────┐
│                UI Layer                   │
│   Sidebar Navigation  │  Content Area   │
├────────────────────────────────────────────┤
│             Business Logic                │
│   迁移向导 │  配置管理  │  历史记录      │
├────────────────────────────────────────────┤
│             System Layer                 │
│   Robocopy   │   mklink /J   │  WMI   │
└────────────────────────────────────────────┘
```

### 13.3 编码规范

#### 13.3.1 导入顺序

```python
import customtkinter as ctk
import tkinter as tk
from tkinter import messagebox, filedialog
import os
import subprocess
from datetime import datetime
```

#### 13.3.2 命名约定

| 类型 | 命名风格 | 示例 |
|------|----------|------|
| 类名 | `PascalCase` | `MigrationApp` |
| 方法名 | `snake_case` | `create_sidebar()` |
| 常量 | `UPPER_SNAKE_CASE` | `APP_NAME` |
| 局部变量 | `snake_case` | `source_path` |

#### 13.3.3 控件命名

| 控件类型 | 前缀 | 示例 |
|----------|------|------|
| CTkFrame | `frame_` | `frame_sidebar` |
| CTkLabel | `label_` | `label_title` |
| CTkButton | `btn_` | `btn_migrate` |
| CTkEntry | `entry_` | `entry_source` |
| CTkCheckBox | `check_` | `check_verify` |

### 13.4 功能模块

#### 13.4.1 仪表盘页面

- 显示迁移统计（总迁移数、成功数、失败数）
- 快速操作按钮（开始迁移、备份开始菜单、查看历史）
- 系统状态检查（磁盘空间、管理员权限）

#### 13.4.2 迁移向导

4 步骤流程：
1. **选择源目录**：复选框列表，显示用户文件夹和开发配置目录
2. **选择目标目录**：驱动器选择或自定义路径
3. **配置选项**：开关选项（验证文件数、创建符号链接等）
4. **确认并执行**：显示摘要，执行迁移

#### 13.4.3 配置管理页面

- 保存/加载迁移配置
- 编辑默认迁移目录列表
- 配置 Robocopy 参数

#### 13.4.4 历史记录页面

- 显示迁移历史（日期、源目录、目标目录、状态）
- 查看详细信息
- 回滚迁移（实验性功能）

#### 13.4.5 符号链接管理页面

- 显示当前用户的目录联接
- 创建/删除联接点
- 验证联接点状态

#### 13.4.6 设置页面

- 常规设置（默认目标驱动器、Robocopy 参数）
- 界面设置（主题、字体大小）
- 关于信息

### 13.5 线程安全

所有耗时操作（文件复制、磁盘检查）必须在后台线程执行，避免 UI 冻结：

```python
def start_migration(self):
    threading.Thread(target=self._run_migration, daemon=True).start()

def _run_migration(self):
    # 耗时操作
    pass
```

---

## 14. HTML 原型规范（v1.12.0 新增）

### 14.1 技术栈

- **文件**：`prototype/windows-app/index.html`
- **样式**：`prototype/windows-app/css/win11-style.css`
- **脚本**：`prototype/windows-app/js/win11-app.js`
- **设计系统**：`prototype/windows-app/DESIGN.md`

### 14.2 设计风格

- **设计系统**：Windows 11 Fluent Design
- **主要颜色**：
  - 主色：`#0066CC`（Windows 蓝）
  - 成功色：`#0D6832`（绿色）
  - 警告色：`#8A5700`（橙色）
  - 危险色：`#C4314B`（红色）
- **字体**：Segoe UI Variable
- **圆角**：8px（小控件）、12px（卡片）、16px（对话框）
- **阴影**：5 级阴影系统（shadow-xs 到 shadow-2xl）

### 14.3 页面结构

```
prototype/windows-app/
├── index.html              # 主原型文件（单页应用）
├── css/
│   └── win11-style.css   # Windows 11 样式
├── js/
│   └── win11-app.js      # 交互逻辑
└── DESIGN.md             # 设计系统规范文档
```

### 14.4 页面列表

| 页面 | 路径 | 功能 |
|------|------|------|
| 仪表盘 | `#dashboard` | 显示统计、快速操作、最近迁移、系统状态 |
| 迁移向导 | `#migrate` | 4 步骤迁移向导 |
| 配置管理 | `#profiles` | 保存/加载配置、编辑目录列表 |
| 历史记录 | `#history` | 显示迁移历史、查看详情、回滚 |
| 符号链接 | `#symlinks` | 管理目录联接 |
| 设置 | `#settings` | 常规设置、界面设置、关于 |

### 14.5 交互规范

- **页面切换**：淡入动画（0.3s ease-out）
- **按钮悬停**：背景色变化 + 向上移动 1px
- **卡片悬停**：向上移动 2px + 阴影增强
- **通知提示**：从右侧滑入，3 秒后自动消失

---

## 15. 设计系统规范（v1.12.0 新增）

### 15.1 文档位置

`prototype/windows-app/DESIGN.md`

### 15.2 规范结构

设计系统规范文档包含 9 个标准章节：

1. **Visual Theme & Atmosphere**（视觉主题与氛围）
2. **Color Palette & Roles**（调色板与角色）
3. **Typography Rules**（排版规则）
4. **Component Stylings**（组件样式）
5. **Layout Principles**（布局原则）
6. **Depth & Elevation**（深度与层级）
7. **Do's and Don'ts**（设计规范与禁忌）
8. **Responsive Behavior**（响应式行为）
9. **Agent Prompt Guide**（AI 代理提示指南）

### 15.3 使用场景

- **UI/UX 设计评审**：设计师和开发者参考
- **用户测试**：展示高保真原型给用户
- **AI 辅助开发**：Cursor、Claude Code 等 AI 编程代理可直接读取设计规范

---

*本文档由 SutChan 维护。如发现规范与实际代码不符，以本文档为准并更新代码。*

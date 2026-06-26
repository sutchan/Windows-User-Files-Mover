# Changelog

本文档记录 Windows-User-Files-Mover 项目的所有 notable changes。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

---

## [Unreleased]

### Added
- 新增 Windows 桌面应用版（Python + CustomTkinter）
- 新增 HTML 高保真原型（Windows 11 风格）
- 新增设计系统规范文档（prototype/windows-app/DESIGN.md）

### Changed
- 更新 README.md，添加新版本说明
- 更新 openspec.md，添加新版本规范

### Fixed
- 修复 Move_DevConfigs_GUI.py 字体解析 Bug（TclError: expected integer but got "YaHei"）

---

## [1.12.0] - 2026-06-26

### Added
- **Windows 桌面应用版**：使用 CustomTkinter 创建现代化 Windows 11 风格 GUI
  - 侧边栏导航
  - 仪表盘页面（统计、快速操作、系统状态）
  - 迁移向导（4 步骤）
  - 配置管理页面
  - 历史记录页面
  - 符号链接管理页面
  - 设置页面
- **HTML 高保真原型**：Windows 11 风格原型设计
  - 完整的 UI/UX 设计展示
  - 可用于设计评审和用户测试
  - 响应式设计（桌面端/移动端）
- **设计系统规范文档**：`prototype/windows-app/DESIGN.md`
  - 9 章节完整设计规范
  - 色彩系统、字体系统、间距系统
  - 组件库规范（基础/复合/业务组件）
  - 交互标准（模式/反馈/错误/空状态）

### Changed
- 更新 README.md：
  - 版本号更新到 v1.12.0
  - 添加 Windows 桌面应用版说明
  - 添加 HTML 原型版说明
  - 添加设计系统规范文档链接
- 更新 docs/openspec.md：
  - 文档版本更新到 1.1.0
  - 对应项目版本更新到 v1.12.0
  - 添加 Windows 桌面应用规范（第 13 章）
  - 添加 HTML 原型规范（第 14 章）
  - 添加设计系统规范（第 15 章）
  - 更新版本矩阵（添加 3 个新版本）
  - 更新目标用户表格（添加 UI/UX 设计师、最终用户）
  - 更新文件结构规范（添加新文件）
  - 更新附录 A（添加 v1.12.0 关键变更记录）

### Fixed
- 修复 `Move_DevConfigs_GUI.py` 字体解析 Bug：
  - 问题：`("Microsoft YaHei UI", 15, "bold")` 含空格字体名，PyInstaller 打包后 Tcl/Tk 解析 font tuple 时拆散参数
  - 修复 1：改用 `tkinter.font.Font` 对象
  - 修复 2：删除 `root.option_add("*Font", ...)` 行
  - 修复 3：删除 `_setup_style` 中所有 `font=` 配置
  - 结果：GUI 使用系统默认字体，PyInstaller 打包后正常运行

### Security
- 无

### Deprecated
- 无

### Removed
- 无

---

## [1.11.0] - 2026-06-26

### Added
- **PowerShell 版本**：`Move-DevConfigs.ps1`
  - 专为开发工具配置文件夹迁移设计
  - 支持 `-WhatIf` 预览
  - 参数化配置
- **开发配置迁移 GUI 版**：`Move_DevConfigs_GUI.py` / `dist/Move_DevConfigs_GUI.exe`
  - 图形化界面版本，专注开发工具配置迁移
  - 支持扫描实际存在的目录
  - 预览模式（WhatIf）
  - 文件数量验证

### Changed
- 更新 README.md：
  - 版本号更新到 v1.11.0
  - 添加 PowerShell 版本说明
  - 添加开发配置迁移 GUI 版说明
  - 更新打包 EXE 文件部分

### Fixed
- **修复硬编码路径问题**：所有文件中的硬编码 `Admin` 用户名已替换为动态获取
  - Python 版本：使用 `os.getlogin()`
  - 批处理版本：使用 `%USERNAME%`
  - PowerShell 版本：使用 `$env:USERNAME`
- **改进错误处理**：修复所有裸 `except` 语句，使用具体的异常类型
- **修复 Explorer 重启问题**：使用 `subprocess.Popen` 替代 `shell start` 命令
- **改进磁盘空间检查**：批处理版本使用 WMIC 替代 `dir` 命令，支持多语言系统
- **修复路径处理**：改进 `run_as_admin` 方法，正确处理带空格的路径参数

### Security
- **优化 robocopy 调用**：使用列表参数替代 shell 字符串，避免注入风险

---

## [1.10.2] - 2025-10-03

### Changed
- 统一所有文件的版本号为 v1.10.2
- 修正 README.md 中的文档目录链接
- 完善各文档的版本信息

### Fixed
- 无

---

## [1.10.1] - 2025-10-02

### Changed
- 批处理版本优化错误处理逻辑
- Python 版本界面美化
- 改进开始菜单备份还原功能
- 完善用户文档

### Fixed
- 无

---

## [1.10.0] - 2025-10-01

### Added
- 实现开始菜单数据库备份和还原
- 优化 ROBOCOPY 命令参数
- 添加更多应用程序数据迁移支持
- 改进用户界面和用户体验

### Changed
- 无

### Fixed
- 无

---

## [1.0.0] - 2025-09-15

### Added
- 初始版本发布
- 文件迁移功能（用户文件夹、应用程序数据）
- 开始菜单备份和还原功能
- 批处理版本（命令行界面）
- Python 版本（图形用户界面）
- EXE 版本（PyInstaller 打包）

---

[unreleased]: https://github.com/sutchan/Windows-User-Files-Mover/compare/v1.12.0...HEAD
[1.12.0]: https://github.com/sutchan/Windows-User-Files-Mover/compare/v1.11.0...v1.12.0
[1.11.0]: https://github.com/sutchan/Windows-User-Files-Mover/compare/v1.10.2...v1.11.0
[1.10.2]: https://github.com/sutchan/Windows-User-Files-Mover/compare/v1.10.1...v1.10.2
[1.10.1]: https://github.com/sutchan/Windows-User-Files-Mover/compare/v1.10.0...v1.10.1
[1.10.0]: https://github.com/sutchan/Windows-User-Files-Mover/compare/v1.0.0...v1.10.0
[1.0.0]: https://github.com/sutchan/Windows-User-Files-Mover/releases/tag/v1.0.0

# Windows-User-Files-Mover

<div align="center">
  <img src="docs/logo_placeholder.png" alt="Windows User Files Mover Logo" width="200">
  <h3>Windows用户文件迁移和开始菜单备份还原工具</h3>
  <p>释放系统盘空间，保护用户数据，管理开始菜单配置</p>
  <a href="https://github.com/sutchan/Windows-User-Files-Mover">
    <img src="https://img.shields.io/badge/GitHub-项目主页-blue.svg">
  </a>
  <img src="https://img.shields.io/badge/版本-v1.11.0-green.svg">
  <img src="https://img.shields.io/badge/支持系统-Windows%207%2F8%2F10%2F11-blue.svg">
</div>

## 📋 项目概述

Windows-User-Files-Mover 是一款专为Windows系统设计的实用工具，旨在帮助用户解决以下关键问题：

- **释放系统盘空间**：将用户文件夹和应用程序数据从系统盘迁移到其他分区
- **保护用户数据**：通过目录联接技术确保应用程序正常访问迁移后的文件
- **管理开始菜单**：备份和还原开始菜单布局、文件夹内容和数据库设置
- **系统优化**：帮助用户更好地管理文件存储，提高系统性能

## 🚀 核心功能

### 1. 文件迁移功能
- **用户文件夹迁移**：将Documents、Downloads、Pictures等标准用户文件夹迁移到其他分区
- **应用程序数据迁移**：支持迁移常用软件的配置文件和数据（如Google、Adobe、Apple等）
- **目录联接技术**：使用Windows Junction Points技术保持文件访问路径不变
- **磁盘空间检查**：操作前自动检查目标分区是否有足够空间
- **安全回滚机制**：在迁移失败时自动恢复原始文件结构

### 2. 开始菜单管理功能
- **布局备份**：将开始菜单布局导出为XML文件
- **文件夹备份**：完整备份开始菜单文件夹内容
- **数据库备份**：备份开始菜单数据库文件
- **完整还原**：还原开始菜单的全部配置和内容
- **资源管理器协同**：智能管理资源管理器进程以确保还原成功

## 📱 版本选择

本工具提供多种版本，满足不同用户的使用需求：

### 1. 批处理版本
- **文件**: `Windows_UserFiles_Mover.bat`
- **特点**: 无需安装依赖，命令行界面，轻量高效，适合系统管理员和高级用户
- **适用场景**: 快速迁移、服务器环境、脚本集成

### 2. Python版本
- **文件**: `Windows_UserFiles_Mover.py`
- **特点**: 图形用户界面(GUI)，操作直观，功能丰富，适合普通用户
- **依赖**: Python 3.6或更高版本
- **适用场景**: 交互式操作、详细日志查看、个性化配置

### 3. 可执行文件版本 (EXE)
- **生成方式**: 通过PyInstaller打包Python版本
- **特点**: 独立可执行文件，无需安装Python环境
- **适用场景**: 在没有Python环境的计算机上使用

### 4. PowerShell版本
- **文件**: `Move-DevConfigs.ps1`
- **特点**: 专为开发工具配置文件夹迁移设计，支持 `-WhatIf` 预览，参数化配置
- **依赖**: PowerShell 5.1+，需要管理员权限运行
- **适用场景**: 迁移 `.vscode`、`.cursor` 等开发工具配置文件夹

## 🛠️ 快速开始

### 批处理版本使用
1. 右键点击 `Windows_UserFiles_Mover.bat`
2. 选择 "以管理员身份运行"
3. 在命令行界面中，输入对应数字选择功能：
   - `1`: 文件迁移
   - `2`: 开始菜单备份
   - `3`: 开始菜单还原
   - `4`: 查看日志
   - `0`: 退出
4. 按照屏幕提示完成操作

### Python版本使用
1. 确保已安装Python 3.6+（安装时勾选"Add Python to PATH"）
2. 方法一：双击运行 `run_python_version.bat`（自动以管理员身份启动）
3. 方法二：在管理员命令提示符中执行 `python Windows_UserFiles_Mover.py`
4. 在图形界面中：
   - 选择相应的选项卡（文件迁移、开始菜单备份、开始菜单还原）
   - 配置源目录、目标目录等参数
   - 点击"开始"按钮执行操作

## 📦 打包EXE文件

如需将Python版打包为独立可执行文件：

1. 以管理员身份运行 `build_exe_robust.bat`
2. 打包完成后，EXE文件将位于`dist`文件夹中

> **注意**：详细打包指南请参考 `docs/exe_packaging_guide.md` 文档

## ⚠️ 重要注意事项

1. **管理员权限**：所有操作必须以管理员身份运行，否则无法创建目录联接或访问系统文件
2. **数据备份**：操作前强烈建议备份重要数据，以防意外情况发生
3. **空间检查**：确保目标分区有足够的可用空间（建议至少是源文件大小的1.2倍）
4. **系统重启**：操作完成后建议重启计算机，确保所有更改生效
5. **资源管理器**：开始菜单还原过程中会临时关闭和重启Windows资源管理器
6. **应用兼容性**：某些特殊应用可能不兼容文件迁移，请在迁移前查阅应用文档

## 📋 系统要求

- **操作系统**：Windows 7/8/10/11（32位或64位）
- **批处理版**：内置ROBOCOPY命令（Windows Vista及以上版本默认包含）
- **Python版**：Python 3.6或更高版本
- **EXE版**：无额外要求
- **硬件**：至少50MB可用内存，足够的磁盘空间用于存储迁移的文件

## 📚 文档目录

项目提供了完整的文档支持：

- [用户指南](docs/user_guide.md) - 详细使用说明和操作步骤
- [安装指南](docs/installation_guide.md) - 各版本安装和配置方法
- [API参考](docs/api_reference.md) - 功能模块和接口详细说明
- [常见问题](docs/faq.md) - 常见问题解答和故障排除
- [优化建议](docs/optimization_suggestions.md) - 项目改进建议和未来计划
- [项目规范（OpenSpec）](docs/openspec.md) - 架构设计、编码、文档与发布规范
- [版本历史](VERSION_HISTORY.md) - 项目版本变更记录

## 🤝 贡献指南

欢迎通过以下方式贡献项目：

1. **报告问题**：在GitHub上提交Issue，详细描述问题和复现步骤
2. **改进建议**：提交功能请求或优化建议
3. **代码贡献**：Fork项目，提交Pull Request
4. **文档改进**：帮助完善项目文档

## 📜 许可证

本项目采用MIT许可证。详见 [LICENSE](LICENSE) 文件。

## 📧 联系方式

项目地址：[https://github.com/sutchan/Windows-User-Files-Mover](https://github.com/sutchan/Windows-User-Files-Mover)

## 📌 版本信息

- **当前版本**：v1.11.0
- **作者**：SutChan
- **最后更新**：2026-06-26

---

<div align="center">
  <p>💖 感谢使用 Windows-User-Files-Mover！祝您使用愉快！ 💖</p>
</div>
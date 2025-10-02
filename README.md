# Windows-User-Files-Mover

GitHub项目地址：https://github.com/sutchan/Windows-User-Files-Mover

Windows用户文件迁移和开始菜单备份还原工具

## 功能概述

### 文件迁移功能
- 将用户文件夹从系统盘迁移到其他分区，释放系统盘空间
- 支持常用应用程序数据迁移（Google、Adobe、Apple等）
- 使用目录联接(junction)技术保持文件访问路径不变

### 开始菜单管理功能
- 备份开始菜单布局到XML文件
- 备份开始菜单文件夹内容和数据库
- 支持完整还原开始菜单设置

## 版本选择

该工具提供两个版本，满足不同用户需求：

### 1. 批处理版本
- **文件**: Windows_UserFiles_Mover.bat
- **特点**: 无需安装依赖，命令行界面，适合系统管理员

### 2. Python版本
- **文件**: Windows_UserFiles_Mover.py
- **特点**: 图形用户界面，操作直观，功能更丰富
- **依赖**: Python 3.6或更高版本

## 使用方法

### 批处理版本
1. 右键点击 `Windows_UserFiles_Mover.bat`
2. 选择 "以管理员身份运行"
3. 按菜单提示选择操作（1-文件迁移，2-开始菜单备份，3-开始菜单还原）

### Python版本
1. 确保已安装Python 3.6+（安装时勾选"Add Python to PATH"）
2. 双击运行 `run_python_version.bat`（自动以管理员身份启动）
3. 在图形界面中选择功能选项卡，按提示完成操作

## 打包成EXE文件

如需将Python版打包成独立可执行文件：

### 简化版打包（推荐）
1. 右键点击 `build_exe_simple.bat`
2. 选择 "以管理员身份运行"
3. 打包完成后，EXE文件位于`dist`文件夹中

### 健壮版打包（适用于复杂环境）
1. 右键点击 `build_exe_robust.bat`
2. 选择 "以管理员身份运行"

**注意**：详细打包指南请参考`EXE_PACKAGING_GUIDE.md`文件

## 注意事项

1. **权限要求**：所有操作必须以管理员身份运行
2. **数据安全**：操作前请备份重要数据
3. **系统稳定性**：开始菜单还原会临时关闭Windows资源管理器
4. **重启建议**：操作完成后请重启电脑确保更改生效
5. **兼容性**：适用于Windows 7/8/10/11操作系统

## 系统要求

- **批处理版**：Windows操作系统
- **Python版**：Windows操作系统 + Python 3.6或更高版本
- **EXE版**：Windows操作系统（无需安装Python）

## 作者信息

作者：SutChan
版本：v1.10.1
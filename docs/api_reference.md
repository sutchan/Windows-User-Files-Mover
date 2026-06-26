# Windows-User-Files-Mover API参考文档

版本：v1.12.0

## 目录

1. [概述](#概述)
2. [批处理版本API](#批处理版本api)
3. [Python版本API](#python版本api)
   - [WindowsUserFilesMover类](#windowsuserfilesmover类)
   - [核心方法](#核心方法)
   - [UI组件方法](#ui组件方法)
   - [工具方法](#工具方法)
4. [命令行接口](#命令行接口)
5. [配置参数](#配置参数)
6. [错误处理](#错误处理)
7. [日志记录](#日志记录)
8. [扩展指南](#扩展指南)

## 概述

本文档详细描述了Windows-User-Files-Mover工具的API接口，包括批处理版本和Python版本中可用的函数、方法、参数和返回值。文档旨在帮助开发者理解工具的内部结构，并为需要扩展或集成工具功能的用户提供指导。

## 批处理版本API

批处理版本主要由函数和标签组成，以下是主要功能函数：

### MIGRATE_FOLDER

**功能**：迁移用户文件夹并创建目录联接

**参数**：
- `source_path`：源文件夹路径
- `target_path`：目标文件夹路径
- `folder_name`：文件夹名称

**返回值**：无，但会设置全局错误状态变量

**调用示例**：
```batch
call :MIGRATE_FOLDER "%USERPROFILE%\Desktop" "%TARGET_DRIVE%\Users\%USER_NAME%\Desktop" "Desktop"
```

### BACKUP_START_MENU

**功能**：备份开始菜单

**参数**：
- `backup_folder`：备份目标文件夹路径

**返回值**：无，但会设置全局错误状态变量

**调用示例**：
```batch
call :BACKUP_START_MENU "%BACKUP_DIR%"
```

### RESTORE_START_MENU

**功能**：还原开始菜单

**参数**：
- `backup_folder`：备份源文件夹路径

**返回值**：无，但会设置全局错误状态变量

**调用示例**：
```batch
call :RESTORE_START_MENU "%BACKUP_DIR%"
```

### CHECK_ADMIN

**功能**：检查是否以管理员权限运行

**参数**：无

**返回值**：
- 0：以管理员权限运行
- 非0：非管理员权限

**调用示例**：
```batch
call :CHECK_ADMIN
if %ERRORLEVEL% neq 0 (
    echo 请以管理员身份运行此脚本
    exit /b 1
)
```

### LOG_MESSAGE

**功能**：记录日志消息

**参数**：
- `message`：要记录的消息

**返回值**：无

**调用示例**：
```batch
call :LOG_MESSAGE "程序开始执行"
```

## Python版本API

Python版本的核心是`WindowsUserFilesMover`类，提供了图形界面和所有功能实现。

### WindowsUserFilesMover类

**功能**：实现Windows用户文件迁移和开始菜单备份还原的主类

**初始化参数**：无

**主要成员变量**：
- `root`：tkinter主窗口对象
- `notebook`：选项卡控件对象
- `log_text`：日志文本框对象
- `migration_status`：迁移状态变量
- `backup_status`：备份状态变量
- `restore_status`：还原状态变量

### 核心方法

#### migrate_app_data

**功能**：迁移用户应用数据文件夹

**参数**：
- `source_path`：源文件夹路径
- `target_path`：目标文件夹路径
- `folder_name`：文件夹名称
- `show_progress`：是否显示进度（布尔值）

**返回值**：字典
```python
{
    "success": True/False,     # 操作是否成功
    "message": "详细信息",     # 操作结果消息
    "errors": []              # 错误列表（如果有）
}
```

#### backup_start_folder

**功能**：备份开始菜单

**参数**：
- `backup_path`：备份目标文件夹路径

**返回值**：字典
```python
{
    "success": True/False,     # 操作是否成功
    "message": "详细信息",     # 操作结果消息
    "errors": []              # 错误列表（如果有）
}
```

#### restore_start_folder

**功能**：还原开始菜单

**参数**：
- `backup_path`：备份源文件夹路径

**返回值**：字典
```python
{
    "success": True/False,     # 操作是否成功
    "message": "详细信息",     # 操作结果消息
    "errors": []              # 错误列表（如果有）
}
```

#### start_migration

**功能**：启动文件迁移流程

**参数**：
- 无（从UI获取配置）

**返回值**：无（结果显示在UI上）

#### start_backup

**功能**：启动开始菜单备份流程

**参数**：
- 无（从UI获取配置）

**返回值**：无（结果显示在UI上）

#### start_restore

**功能**：启动开始菜单还原流程

**参数**：
- 无（从UI获取配置）

**返回值**：无（结果显示在UI上）

### UI组件方法

#### configure_styles

**功能**：配置UI样式

**参数**：无

**返回值**：无

#### init_migrate_tab

**功能**：初始化文件迁移选项卡

**参数**：无

**返回值**：无

#### init_backup_tab

**功能**：初始化开始菜单备份选项卡

**参数**：无

**返回值**：无

#### init_restore_tab

**功能**：初始化开始菜单还原选项卡

**参数**：无

**返回值**：无

#### browse_source_path

**功能**：浏览源文件夹路径

**参数**：无

**返回值**：无（更新UI中的文本框）

#### browse_target_path

**功能**：浏览目标文件夹路径

**参数**：无

**返回值**：无（更新UI中的文本框）

#### browse_backup_path

**功能**：浏览备份文件夹路径

**参数**：无

**返回值**：无（更新UI中的文本框）

#### update_log

**功能**：更新日志显示

**参数**：
- `message`：要显示的日志消息
- `is_error`：是否为错误消息（布尔值，默认False）

**返回值**：无

### 工具方法

#### run_robocopy

**功能**：运行ROBOCOPY命令复制文件

**参数**：
- `source`：源路径
- `destination`：目标路径
- `options`：ROBOCOPY选项（字符串）

**返回值**：字典
```python
{
    "success": True/False,     # 操作是否成功
    "exit_code": 整数,         # ROBOCOPY退出代码
    "output": "输出内容",      # 命令输出
    "errors": []              # 错误列表（如果有）
}
```

#### create_junction

**功能**：创建目录联接(junction point)

**参数**：
- `junction_path`：联接点路径
- `target_path`：目标路径

**返回值**：布尔值（成功返回True）

#### check_admin

**功能**：检查是否以管理员权限运行

**参数**：无

**返回值**：布尔值（管理员权限返回True）

#### restart_explorer

**功能**：重启Windows资源管理器

**参数**：无

**返回值**：布尔值（成功返回True）

#### log_to_file

**功能**：将消息记录到日志文件

**参数**：
- `message`：要记录的消息

**返回值**：无

## 命令行接口

### 批处理版本命令行

批处理版本主要通过交互式菜单操作，但也可以通过设置环境变量进行配置：

**常用命令**：
```batch
Windows_UserFiles_Mover.bat  # 启动交互式菜单
Windows_UserFiles_Mover.bat /S  # 静默模式（如果支持）
```

**环境变量配置**：
- `TARGET_DRIVE`：设置目标驱动器
- `LOG_FILE`：设置日志文件路径
- `BACKUP_DIR`：设置备份目录

### Python版本命令行

Python版本主要提供图形界面，但也支持简单的命令行参数：

**基本命令**：
```python
python Windows_UserFiles_Mover.py  # 启动图形界面
python Windows_UserFiles_Mover.py --help  # 显示帮助信息（如果支持）
```

## 配置参数

### 批处理版本配置

批处理版本使用脚本顶部的配置区域进行设置：

```batch
:: 配置区域 - 可根据需要修改
set APP_VERSION=v1.12.0
set APP_AUTHOR=SutChan
set LOG_FILE=Windows_UserFiles_Mover.log
set ROBOCOPY_OPTIONS=/E /COPYALL /DCOPY:DAT /ZB /MT:16 /R:1 /W:1
```

### Python版本配置

Python版本的配置主要通过UI设置，也可以通过修改类中的常量进行配置：

```python
class WindowsUserFilesMover:
    VERSION = "v1.12.0"
    LOG_FILE = "Windows_UserFiles_Mover.log"
    ROBOCOPY_OPTIONS = "/E /COPYALL /DCOPY:DAT /ZB /MT:16 /R:1 /W:1"
```

## 错误处理

### 批处理版本错误处理

批处理版本通过以下方式处理错误：

- 使用错误状态变量记录操作结果
- 通过日志文件记录详细错误信息
- 在控制台显示错误消息

**常见错误代码**：
- `1`：权限不足
- `2`：路径不存在
- `3`：复制文件失败
- `4`：创建目录联接失败

### Python版本错误处理

Python版本使用以下错误处理机制：

- 返回包含错误信息的结果字典
- 将错误记录到日志文件
- 在UI上显示错误消息
- 使用try-except块捕获异常

**异常类型**：
- `FileNotFoundError`：文件或目录不存在
- `PermissionError`：权限不足
- `OSError`：操作系统错误
- `subprocess.SubprocessError`：子进程执行错误

## 日志记录

### 日志文件格式

两种版本的日志文件格式类似，包含以下信息：

```
[时间戳] 消息类型: 消息内容
```

### 日志级别

日志级别包括：
- `INFO`：一般信息
- `WARNING`：警告信息
- `ERROR`：错误信息
- `SUCCESS`：成功信息

### 日志文件位置

默认日志文件位置：
- 与主程序在同一目录
- 文件名为 `Windows_UserFiles_Mover.log`

## 扩展指南

### 扩展批处理版本

要扩展批处理版本功能，可以：

1. 在脚本中添加新的功能函数
2. 修改主菜单以包含新功能
3. 更新错误处理和日志记录

### 扩展Python版本

要扩展Python版本功能，可以：

1. 在`WindowsUserFilesMover`类中添加新方法
2. 在UI中添加新控件或选项卡
3. 修改现有方法以支持新功能
4. 确保新功能遵循现有的错误处理模式

### 开发规范

1. **保持兼容性**：确保扩展功能兼容所有支持的Windows版本
2. **权限处理**：检查并处理必要的管理员权限
3. **错误处理**：提供详细的错误信息和恢复建议
4. **代码注释**：添加清晰的函数级和代码级注释
5. **测试验证**：在多个Windows版本上测试新功能

---

本文档由 SutChan 维护，版本：v1.12.0
最后更新时间：2025-10-03
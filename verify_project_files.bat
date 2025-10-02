@echo off
chcp 65001 >nul
REM Windows用户文件迁移工具 - 项目文件验证脚本
REM 作者: SutChan
REM 版本: v1.10.1
REM 项目地址: https://github.com/sutchan/Windows-User-Files-Mover

ECHO.==================================================
ECHO.正在验证Windows用户文件迁移工具项目文件...
ECHO.项目地址: https://github.com/sutchan/Windows-User-Files-Mover
ECHO.版本: v1.10.1
ECHO.==================================================

REM 检查主要文件
IF EXIST "Windows_UserFiles_Mover.py" (
    ECHO.[✓] Windows_UserFiles_Mover.py 存在
) ELSE (
    ECHO.[✗] Windows_UserFiles_Mover.py 缺失
)

IF EXIST "requirements.txt" (
    ECHO.[✓] requirements.txt 存在
) ELSE (
    ECHO.[✗] requirements.txt 缺失
)

IF EXIST "run_python_version.bat" (
    ECHO.[✓] run_python_version.bat 存在
) ELSE (
    ECHO.[✗] run_python_version.bat 缺失
)

IF EXIST "Windows_UserFiles_Mover.bat" (
    ECHO.[✓] Windows_UserFiles_Mover.bat 存在
) ELSE (
    ECHO.[✗] Windows_UserFiles_Mover.bat 缺失
)

IF EXIST "README.md" (
    ECHO.[✓] README.md 存在
) ELSE (
    ECHO.[✗] README.md 缺失
)

ECHO.
ECHO.==================================================
ECHO.项目文件验证完成！
ECHO.
ECHO.使用说明：
ECHO.1. 批处理版本：直接运行 Windows_UserFiles_Mover.bat
ECHO.2. Python版本：先安装Python 3.6+，然后运行 run_python_version.bat
ECHO.
ECHO.注意事项：
ECHO.- 所有操作都需要管理员权限
ECHO.- Python版本需要预先安装Python环境
ECHO.==================================================

PAUSE
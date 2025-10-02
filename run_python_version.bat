@echo off
REM Windows用户文件迁移工具 - Python版本启动器
REM 作者: SutChan
REM 版本: v1.10.1
REM 项目地址: https://github.com/sutchan/Windows-User-Files-Mover

REM 设置窗口标题和颜色
TITLE Windows用户文件迁移工具 - Python版本
COLOR 0A

echo Windows用户文件迁移工具 - Python版本
echo 项目地址: https://github.com/sutchan/Windows-User-Files-Mover
echo 版本: v1.10.1
echo 作者: SutChan
echo.

REM 检查Python是否安装
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo 错误: 未找到Python。请先安装Python 3.6或更高版本。
    echo 可以从以下网址下载: https://www.python.org/downloads/
    pause
    exit /b 1
)

REM 检查脚本是否存在
IF NOT EXIST "%~dp0Windows_UserFiles_Mover.py" (
    echo 错误: 未找到Windows_UserFiles_Mover.py脚本。
    pause
    exit /b 1
)

REM 以管理员权限运行Python脚本
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo 请以管理员身份运行此脚本...
    powershell -Command "Start-Process '%~dp0run_python_version.bat' -Verb RunAs"
    exit /b 0
)

REM 运行Python脚本
cls
python "%~dp0Windows_UserFiles_Mover.py"

REM 等待用户按任意键退出
pause
@echo off
chcp 65001 >nul
REM Windows用户文件迁移工具 - 简化版打包脚本
REM 作者: SutChan
REM 版本: v1.10.1
REM 项目地址: https://github.com/sutchan/Windows-User-Files-Mover

TITLE 简化版打包Python脚本为EXE文件
COLOR 0A

ECHO.==================================================
ECHO.正在准备将Python脚本打包为EXE文件...
ECHO.项目地址: https://github.com/sutchan/Windows-User-Files-Mover
ECHO.==================================================

REM 检查Python是否安装
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO.错误: 未找到Python。请先安装Python 3.6或更高版本。
    ECHO.可以从以下网址下载: https://www.python.org/downloads/
    PAUSE
    EXIT /B 1
) ELSE (
    python --version
    ECHO.Python环境已检测到
)

REM 安装PyInstaller
ECHO.
ECHO.正在安装PyInstaller...

pip install pyinstaller --upgrade >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO.错误: 无法安装PyInstaller。请确保pip可用。
    PAUSE
    EXIT /B 1
) ELSE (
    ECHO.PyInstaller安装成功
)

REM 创建打包目录
SET "BUILD_DIR=%~dp0build"
SET "DIST_DIR=%~dp0dist"

IF EXIST "%BUILD_DIR%" (
    ECHO.正在清理旧的构建目录...
    RD /S /Q "%BUILD_DIR%" >nul 2>&1
)

IF EXIST "%DIST_DIR%" (
    ECHO.正在清理旧的发布目录...
    RD /S /Q "%DIST_DIR%" >nul 2>&1
)

REM 使用PyInstaller打包脚本（简化版，不使用图标）
ECHO.
ECHO.正在使用PyInstaller打包脚本...
ECHO.这可能需要几分钟时间，请耐心等待...

pyinstaller --onefile --windowed --name "Windows_UserFiles_Mover" ^
    "%~dp0Windows_UserFiles_Mover.py"

IF %ERRORLEVEL% NEQ 0 (
    ECHO.错误: 打包过程中发生错误
    PAUSE
    EXIT /B 1
) ELSE (
    ECHO.打包成功
)

REM 复制必要的文件到发布目录
ECHO.
ECHO.正在复制必要的文件到发布目录...

COPY /Y "%~dp0Windows_UserFiles_Mover.bat" "%DIST_DIR%\">nul 2>&1
COPY /Y "%~dp0README.md" "%DIST_DIR%\">nul 2>&1

ECHO.
ECHO.==================================================
ECHO.EXE文件打包完成！
ECHO.
ECHO.打包后的文件位于：%DIST_DIR%
ECHO.
ECHO.包含的文件：
ECHO.- Windows_UserFiles_Mover.exe - 可执行文件
ECHO.- Windows_UserFiles_Mover.bat - 批处理版本
ECHO.- README.md - 使用说明
ECHO.
ECHO.使用说明：
ECHO.1. 双击Windows_UserFiles_Mover.exe直接运行程序
ECHO.2. 程序需要以管理员权限运行
ECHO.==================================================

PAUSE
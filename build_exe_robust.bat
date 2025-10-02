@echo off
REM 强制使用UTF-8编码
chcp 65001 >nul

REM Windows用户文件迁移工具 - 健壮版打包脚本
REM 作者: SutChan
REM 版本: v1.10.1
REM 项目地址: https://github.com/sutchan/Windows-User-Files-Mover

TITLE 健壮版Python脚本打包为EXE文件
COLOR 0A

ECHO.
ECHO ==================================================
ECHO Windows用户文件迁移工具 - EXE打包脚本（健壮版）
ECHO 项目地址: https://github.com/sutchan/Windows-User-Files-Mover
ECHO ==================================================
ECHO.

REM 设置临时环境变量以支持UTF-8
SET PYTHONUTF8=1

REM 定义常用Python版本路径数组
SET "PYTHON_PATHS[0]=%ProgramFiles%\Python311\python.exe"
SET "PYTHON_PATHS[1]=%ProgramFiles(x86)%\Python311\python.exe"
SET "PYTHON_PATHS[2]=%USERPROFILE%\AppData\Local\Programs\Python\Python311\python.exe"
SET "PYTHON_PATHS[3]=%ProgramFiles%\Python310\python.exe"
SET "PYTHON_PATHS[4]=%ProgramFiles(x86)%\Python310\python.exe"
SET "PYTHON_PATHS[5]=%USERPROFILE%\AppData\Local\Programs\Python\Python310\python.exe"
SET "PYTHON_PATHS[6]=%ProgramFiles%\Python39\python.exe"
SET "PYTHON_PATHS[7]=%ProgramFiles(x86)%\Python39\python.exe"
SET "PYTHON_PATHS[8]=%USERPROFILE%\AppData\Local\Programs\Python\Python39\python.exe"

REM 尝试在系统PATH中查找Python
ECHO 正在查找Python环境...
WHERE python >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    SET "PYTHON_EXE=python"
    ECHO 找到系统PATH中的Python
) ELSE (
    REM 尝试在常见安装位置查找Python
    FOR /L %%i IN (0,1,8) DO (
        IF DEFINED PYTHON_PATHS[%%i] (
            SETLOCAL ENABLEDELAYEDEXPANSION
            SET "TEST_PATH=!PYTHON_PATHS[%%i]!"
            ENDLOCAL & SET "TEST_PATH=%TEST_PATH%"
            IF EXIST "%TEST_PATH%" (
                SET "PYTHON_EXE=%TEST_PATH%"
                ECHO 找到Python: %TEST_PATH%
                GOTO :PYTHON_FOUND
            )
        )
    )
    
    :PYTHON_FOUND
    IF NOT DEFINED PYTHON_EXE (
        ECHO 错误: 未找到Python。请先安装Python 3.6或更高版本。
        ECHO 可以从以下网址下载: https://www.python.org/downloads/
        ECHO 安装时请勾选"Add Python to PATH"选项
        PAUSE
        EXIT /B 1
    )
)

REM 显示Python版本信息
ECHO.
ECHO 正在检查Python版本...
"%PYTHON_EXE%" --version
IF %ERRORLEVEL% NEQ 0 (
    ECHO 错误: Python版本检查失败
    PAUSE
    EXIT /B 1
)

REM 安装PyInstaller
ECHO.
ECHO 正在安装或更新PyInstaller...
"%PYTHON_EXE%" -m pip install pyinstaller --upgrade >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO 警告: PyInstaller安装失败，尝试使用--user参数...
    "%PYTHON_EXE%" -m pip install pyinstaller --upgrade --user >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 错误: 无法安装PyInstaller
        ECHO 请手动安装: "%PYTHON_EXE%" -m pip install pyinstaller
        PAUSE
        EXIT /B 1
    )
)
ECHO PyInstaller安装成功

REM 设置打包目录
SET "BUILD_DIR=%~dp0build"
SET "DIST_DIR=%~dp0dist"

REM 清理旧的构建文件
ECHO.
ECHO 正在清理旧的构建文件...
IF EXIST "%~dp0Windows_UserFiles_Mover.spec" (
    DEL /F /Q "%~dp0Windows_UserFiles_Mover.spec" >nul 2>&1
)
IF EXIST "%BUILD_DIR%" (
    RD /S /Q "%BUILD_DIR%" >nul 2>&1
)
IF EXIST "%DIST_DIR%" (
    RD /S /Q "%DIST_DIR%" >nul 2>&1
)

REM 创建必要的目录
MKDIR "%DIST_DIR%" >nul 2>&1

REM 使用PyInstaller打包（极简模式）
ECHO.
ECHO 正在使用PyInstaller打包脚本...
ECHO 这可能需要几分钟时间，请耐心等待...

REM 尝试直接调用pyinstaller命令
pyinstaller --onefile --windowed --name "Windows_UserFiles_Mover" "%~dp0Windows_UserFiles_Mover.py"

IF %ERRORLEVEL% NEQ 0 (
    ECHO 警告: 直接调用pyinstaller失败，尝试通过Python模块调用...
    "%PYTHON_EXE%" -m PyInstaller --onefile --windowed --name "Windows_UserFiles_Mover" "%~dp0Windows_UserFiles_Mover.py"
    
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 错误: 打包过程中发生错误
        ECHO 请尝试手动打包：
        ECHO 1. 打开命令提示符（管理员）
        ECHO 2. 导航到项目目录
        ECHO 3. 执行："%PYTHON_EXE%" -m pip install pyinstaller
        ECHO 4. 执行："%PYTHON_EXE%" -m PyInstaller --onefile --windowed --name "Windows_UserFiles_Mover" Windows_UserFiles_Mover.py
        PAUSE
        EXIT /B 1
    )
)

ECHO 打包成功

REM 复制必要文件到发布目录
ECHO.
ECHO 正在复制必要的文件...
COPY /Y "%~dp0Windows_UserFiles_Mover.bat" "%DIST_DIR%">nul 2>&1
COPY /Y "%~dp0README.md" "%DIST_DIR%">nul 2>&1

ECHO.
ECHO ==================================================
ECHO EXE文件打包完成！
ECHO.
ECHO 打包后的文件位于：%DIST_DIR%
ECHO.
ECHO 包含的文件：
ECHO - Windows_UserFiles_Mover.exe - 可执行文件
ECHO - Windows_UserFiles_Mover.bat - 批处理版本
ECHO - README.md - 使用说明
ECHO.
ECHO 使用方法：
ECHO 1. 双击Windows_UserFiles_Mover.exe直接运行程序
ECHO 2. 程序需要以管理员权限运行
ECHO ==================================================

ECHO.
ECHO 如果在其他计算机上运行失败，可能需要：
ECHO 1. 确保目标计算机上安装了Visual C++ Redistributable
ECHO 2. 以管理员身份运行程序
ECHO.

PAUSE
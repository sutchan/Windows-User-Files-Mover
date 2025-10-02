@echo off
chcp 65001 >nul
REM 检查Python安装位置
REM 作者: SutChan
REM 版本: v1.10.1
REM 项目地址: https://github.com/sutchan/Windows-User-Files-Mover

TITLE 检查Python安装位置
COLOR 0A

ECHO.==================================================
ECHO.正在检查Python安装位置...
ECHO.项目地址: https://github.com/sutchan/Windows-User-Files-Mover
ECHO.==================================================

REM 检查系统环境变量中的Python
ECHO.检查系统环境变量中的Python...
WHERE python >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    WHERE python
    python --version 2>nul
) ELSE (
    ECHO.未在系统环境变量中找到Python
)

REM 检查常见的Python安装位置
ECHO.
ECHO.检查常见的Python安装位置...

REM 检查Program Files目录
IF EXIST "%ProgramFiles%\Python311\python.exe" (
    ECHO.找到Python 3.11: %ProgramFiles%\Python311\python.exe
    "%ProgramFiles%\Python311\python.exe" --version 2>nul
) ELSE (
    ECHO.未找到Python 3.11在Program Files目录
)

IF EXIST "%ProgramFiles(x86)%\Python311\python.exe" (
    ECHO.找到Python 3.11 (x86): %ProgramFiles(x86)%\Python311\python.exe
    "%ProgramFiles(x86)%\Python311\python.exe" --version 2>nul
) ELSE (
    ECHO.未找到Python 3.11 (x86)在Program Files(x86)目录
)

REM 检查用户目录下的AppData
IF EXIST "%USERPROFILE%\AppData\Local\Programs\Python\Python311\python.exe" (
    ECHO.找到Python 3.11在用户目录: %USERPROFILE%\AppData\Local\Programs\Python\Python311\python.exe
    "%USERPROFILE%\AppData\Local\Programs\Python\Python311\python.exe" --version 2>nul
) ELSE (
    ECHO.未找到Python 3.11在用户AppData目录
)

REM 检查较旧的Python版本
IF EXIST "%ProgramFiles%\Python39\python.exe" (
    ECHO.找到Python 3.9: %ProgramFiles%\Python39\python.exe
    "%ProgramFiles%\Python39\python.exe" --version 2>nul
) ELSE (
    ECHO.未找到Python 3.9在Program Files目录
)

IF EXIST "%ProgramFiles(x86)%\Python39\python.exe" (
    ECHO.找到Python 3.9 (x86): %ProgramFiles(x86)%\Python39\python.exe
    "%ProgramFiles(x86)%\Python39\python.exe" --version 2>nul
) ELSE (
    ECHO.未找到Python 3.9 (x86)在Program Files(x86)目录
)

ECHO.
ECHO.==================================================
ECHO.Python安装检查完成
ECHO.如果未找到Python，请从以下网址下载并安装:
ECHO.https://www.python.org/downloads/
ECHO.安装时请勾选"Add Python to PATH"选项
ECHO.==================================================

PAUSE
@echo off
chcp 65001 >nul
REM Windows用户文件迁移工具 - 项目构建脚本
REM 作者: SutChan
REM 版本: v1.10.1
REM 项目地址: https://github.com/sutchan/Windows-User-Files-Mover

TITLE 项目构建验证
COLOR 0A

REM 检查项目文件是否完整
ECHO.
ECHO.正在检查项目文件完整性...

SET "MISSING_FILES="

IF NOT EXIST "Windows_UserFiles_Mover.py" SET "MISSING_FILES=Windows_UserFiles_Mover.py"
IF NOT EXIST "requirements.txt" SET "MISSING_FILES=%MISSING_FILES% requirements.txt"
IF NOT EXIST "run_python_version.bat" SET "MISSING_FILES=%MISSING_FILES% run_python_version.bat"
IF NOT EXIST "README.md" SET "MISSING_FILES=%MISSING_FILES% README.md"

IF DEFINED MISSING_FILES (
    ECHO.错误: 以下文件缺失:
    ECHO.%MISSING_FILES%
    PAUSE
    EXIT /B 1
) ELSE (
    ECHO.所有必需文件都已存在
)

REM 检查Python环境
ECHO.
ECHO.正在检查Python环境...

python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO.错误: 未找到Python。请先安装Python 3.6或更高版本。
    ECHO.可以从以下网址下载: https://www.python.org/downloads/
    PAUSE
    EXIT /B 1
) ELSE (
    python --version
    ECHO.Python环境检查通过
)

REM 检查脚本语法
ECHO.
ECHO.正在检查Python脚本语法...

python -m py_compile Windows_UserFiles_Mover.py
IF %ERRORLEVEL% NEQ 0 (
    ECHO.错误: Python脚本语法检查失败
    PAUSE
    EXIT /B 1
) ELSE (
    ECHO.Python脚本语法检查通过
)

REM 清理编译后的文件
DEL /Q __pycache__

REM 显示构建成功信息
ECHO.
ECHO.==================================================
ECHO.项目构建验证成功！
ECHO.
ECHO.使用方法：
ECHO.1. 双击运行 run_python_version.bat 文件启动Python版本的工具
ECHO.2. 或者继续使用原有的 Windows_UserFiles_Mover.bat 批处理版本
ECHO.
ECHO.注意事项：
ECHO.- 工具需要以管理员权限运行
ECHO.- Python版本需要安装Python 3.6或更高版本
ECHO.==================================================

PAUSE
@ECHO off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

rem ==================================================
rem Windows User Files Mover - 用户文件迁移工具
rem 版本: v1.10.1
rem 作者: SutChan
rem 功能: 文件迁移与开始菜单备份还原
rem ==================================================

rem 设置环境变量
SET "build=v1.10.1"
SET "author=SutChan"
SET "title=Windows User Files Mover 用户文件迁移工具"

rem 设置默认目标驱动器
SET "target_drive=E:" 

TITLE %title% by %author% Ver:%build%

rem 检查管理员权限
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    CLS
    ECHO 错误: 需要管理员权限才能运行此程序！
    ECHO 请右键点击批处理文件，选择"以管理员身份运行"。
    PAUSE >nul
    exit /B 1
)

:MAIN_MENU
CLS
color e0
ECHO.    ┏                     ┓
ECHO.        【 %title% 】
ECHO.    
ECHO.        作者  : %author%
ECHO.        版本  : %build%
ECHO.        项目地址: https://github.com/sutchan/Windows-User-Files-Mover
ECHO.    ┗                     ┛
ECHO.
ECHO.    [1] 执行文件迁移
ECHO.    [2] 开始菜单备份
ECHO.    [3] 开始菜单还原
ECHO.    [0] 退出程序
ECHO.

SET /P choice=请选择操作 (0-3): 

IF "%choice%"=="0" GOTO EXIT_PROGRAM
IF "%choice%"=="1" GOTO MIGRATE
IF "%choice%"=="2" GOTO BACKUP_STARTMENU
IF "%choice%"=="3" GOTO RESTORE_STARTMENU

ECHO 无效的选择，请重新输入。
PAUSE >nul
GOTO MAIN_MENU

rem ==================================================
rem 函数: 迁移文件夹并创建链接
rem 参数: %1 - 源文件夹路径
rem       %2 - 目标文件夹路径
rem ==================================================
:MIGRATE_FOLDER
    SET "source_folder=%~1"
    SET "target_folder=%~2"
    SET "folder_name=%~nx1"
    
    ECHO.
    ECHO [处理] %folder_name%
    
    rem 检查源文件夹是否存在
    IF NOT EXIST "%source_folder%" (
        ECHO 警告: 源文件夹不存在，跳过 - %source_folder%
        GOTO :EOF
    )
    
    rem 创建目标文件夹（包括父目录）
    FOR %%I IN ("%target_folder%") DO (
        IF NOT EXIST "%%~dpI" (
            MKDIR "%%~dpI" >nul 2>&1
            IF !ERRORLEVEL! NEQ 0 (
                ECHO 错误: 无法创建目标文件夹 - %%~dpI
                GOTO :EOF
            )
        )
    )
    
    rem 复制文件
    ECHO 正在复制文件...
    ROBOCOPY "%source_folder%" "%target_folder%" /E /COPYALL /XJ /R:3 /W:10
    IF !ERRORLEVEL! GEQ 8 (
        ECHO 错误: 文件复制失败！
        GOTO :EOF
    )
    
    rem 备份并删除源文件夹
    ECHO 正在创建链接...
    IF EXIST "%source_folder%.backup" RMDIR "%source_folder%.backup" /S /Q >nul 2>&1
    IF EXIST "%source_folder%" (
        RENAME "%source_folder%" "%folder_name%.backup" >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 (
            ECHO 警告: 无法重命名源文件夹，尝试强制删除
            RMDIR "%source_folder%" /S /Q >nul 2>&1
            IF !ERRORLEVEL! NEQ 0 (
                ECHO 错误: 无法删除源文件夹，操作失败！
                GOTO :EOF
            )
        )
    )
    
    rem 创建目录链接
    MKLINK /J "%source_folder%" "%target_folder%" >nul 2>&1
    IF !ERRORLEVEL! NEQ 0 (
        ECHO 错误: 无法创建目录链接！
        rem 尝试恢复源文件夹
        IF EXIST "%source_folder%.backup" (
            RENAME "%source_folder%.backup" "%folder_name%" >nul 2>&1
        )
        GOTO :EOF
    )
    
    rem 删除备份
    IF EXIST "%source_folder%.backup" RMDIR "%source_folder%.backup" /S /Q >nul 2>&1
    ECHO [完成] %folder_name%
GOTO :EOF

rem ==================================================
rem 函数: 清理临时文件夹
rem ==================================================
:CLEAN_TEMP_FOLDERS
    ECHO.
    ECHO 正在清理临时文件夹...
    
    SET "temp_folders[\]=%USERPROFILE%\AppData\Local\TEMP"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\Vidown"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\VTWAFDI"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\Wandoujia"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\Sierra Wireless"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\LDSGameAssistant"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\WNS"
    SET "temp_folders[\]=%USERPROFILE%\AppData\Roaming\wps"
    
    FOR /F "tokens=2* delims=[]" %%A IN ('SET temp_folders[') DO (
        IF EXIST "%%B" (
            ECHO 清理: %%B
            RMDIR "%%B" /S /Q >nul 2>&1
        )
    )
GOTO :EOF

:MIGRATE
CLS
ECHO.
ECHO ==================================================
ECHO         文件迁移功能
ECHO ==================================================
ECHO 此功能将用户文件从系统盘迁移到其他分区，并创建目录链接。
ECHO 警告: 请确保目标驱动器有足够空间，操作前建议备份重要数据！
ECHO.

SET /P "custom_drive=请输入目标驱动器 (默认为 %target_drive%, 直接按回车使用默认值): "
IF NOT "%custom_drive%"=="" SET "target_drive=%custom_drive:~0,2%"

ECHO.
ECHO 目标驱动器: %target_drive%
ECHO.

SET /P "confirm=确认要继续吗？(Y/N): "
IF /I NOT "%confirm%"=="Y" GOTO MAIN_MENU

CALL :CLEAN_TEMP_FOLDERS

rem 定义要迁移的文件夹列表
ECHO.
ECHO 开始迁移文件...
ECHO ==================================================

CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Google" "%target_drive%\Users\Admin\AppData\Local\Google"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth" "%target_drive%\Dropbox\My\Google\GoogleEarth"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Adobe" "%target_drive%\Users\Admin\AppData\Local\Adobe"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Apple Computer" "%target_drive%\Users\Admin\AppData\Local\Apple Computer"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Apple Computer" "%target_drive%\Users\Admin\AppData\Roaming\Apple Computer"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Wandoujia2" "%target_drive%\Users\Admin\AppData\Local\Wandoujia2"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Wandoujia2" "%target_drive%\Users\Admin\AppData\Roaming\Wandoujia2"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Winamp" "%target_drive%\Users\Admin\AppData\Roaming\Winamp"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\ytmediacenter" "%target_drive%\Users\Admin\AppData\Roaming\ytmediacenter"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Yodao" "%target_drive%\Users\Admin\AppData\Local\Yodao"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\aef" "%target_drive%\Users\Admin\AppData\Local\aef"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Netease" "%target_drive%\Users\Admin\AppData\Local\Netease"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\LocalLow\SogouPY" "%target_drive%\Users\Admin\AppData\LocalLow\SogouPY"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\LocalLow\SogouPY.users" "%target_drive%\Users\Admin\AppData\LocalLow\SogouPY.users"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\5kplayer" "%target_drive%\Users\Admin\AppData\Roaming\5kplayer"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Adobe" "%target_drive%\Users\Admin\AppData\Roaming\Adobe"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\SketchUp" "%target_drive%\Users\Admin\AppData\Roaming\SketchUp"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Teiron" "%target_drive%\Users\Admin\AppData\Roaming\Teiron"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Kingsoft" "%target_drive%\Users\Admin\AppData\Roaming\Kingsoft"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Lantern" "%target_drive%\Users\Admin\AppData\Roaming\Lantern"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Tencent" "%target_drive%\Users\Admin\AppData\Roaming\Tencent"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\Thea Render" "%target_drive%\Users\Admin\AppData\Roaming\Thea Render"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Roaming\youku" "%target_drive%\Users\Admin\AppData\Roaming\youku"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Microsoft" "%target_drive%\Users\Admin\AppData\Local\Microsoft"
CALL :MIGRATE_FOLDER "%USERPROFILE%\AppData\Local\Comms" "%target_drive%\Users\Admin\AppData\Local\Comms"

ECHO ==================================================
COLOR 2F
ECHO.
ECHO 操作已完成！感谢你使用 %title%！
ECHO 建议重启电脑以确保所有更改生效。
ECHO.
PAUSE
GOTO MAIN_MENU

:BACKUP_STARTMENU
CLS
ECHO.
ECHO ==================================================
ECHO         开始菜单备份功能
ECHO ==================================================
ECHO 此功能将备份开始菜单布局、文件夹内容和数据库。
ECHO.

SET "default_backup_path=%CD%"
SET /P "backup_path=请选择备份目标路径 (默认为 %default_backup_path%): "
IF "%backup_path%"=="" SET "backup_path=%default_backup_path%"

rem 检查备份路径是否存在，不存在则创建
IF NOT EXIST "%backup_path%" (
    MKDIR "%backup_path%" >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 错误: 无法创建备份路径！
        PAUSE
        GOTO MAIN_MENU
    )
)

rem 创建带时间戳的备份目录
SET "timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%"
SET "timestamp=%timestamp: =0%"  rem 替换空格为0
SET "backup_dir=%backup_path%\StartMenu_Backup_%timestamp%"

ECHO.
ECHO 正在创建备份目录: %backup_dir%
MKDIR "%backup_dir%" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO 错误: 无法创建备份目录！
    PAUSE
    GOTO MAIN_MENU
)

ECHO.
ECHO 开始菜单备份进程:
ECHO ==================================================

rem 1. 使用PowerShell备份开始菜单布局
ECHO [1/3] 正在使用PowerShell备份开始菜单布局...
PowerShell -Command "Export-StartLayout -Path '%backup_dir%\StartLayout.xml'" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO 警告: 开始菜单布局备份可能不完全成功！
)

rem 2. 备份开始菜单文件夹
ECHO [2/3] 正在备份开始菜单文件夹...
ROBOCOPY "%APPDATA%\Microsoft\Windows\Start Menu" "%backup_dir%\Start Menu" /E /COPYALL /XJ /R:3 /W:5
IF %ERRORLEVEL% GEQ 8 (
    ECHO 错误: 开始菜单文件夹备份失败！
)

rem 3. 备份开始菜单数据库
ECHO [3/3] 正在备份开始菜单数据库...
IF EXIST "%LOCALAPPDATA%\TileDataLayer\Database" (
    MKDIR "%backup_dir%\TileDataLayer\Database" >nul 2>&1
    ROBOCOPY "%LOCALAPPDATA%\TileDataLayer\Database" "%backup_dir%\TileDataLayer\Database" /E /COPYALL /XJ /R:3 /W:5
    IF %ERRORLEVEL% GEQ 8 (
        ECHO 错误: 开始菜单数据库备份失败！
    )
) ELSE (
    ECHO 信息: 未找到开始菜单数据库，跳过此步骤。
)

ECHO ==================================================
COLOR 2F
ECHO.
ECHO 开始菜单备份完成！
ECHO 备份文件保存在: %backup_dir%
ECHO 请妥善保存备份文件。
ECHO.
PAUSE
GOTO MAIN_MENU

:RESTORE_STARTMENU
CLS
ECHO.
ECHO ==================================================
ECHO         开始菜单还原功能
ECHO ==================================================
ECHO 注意: 还原开始菜单需要管理员权限，并且还原后需要重启电脑才能生效。
ECHO 此操作会临时关闭Windows资源管理器。
ECHO.

SET /P "restore_path=请输入备份文件所在路径: "

IF NOT EXIST "%restore_path%" (
    ECHO 错误: 备份路径不存在！
    PAUSE
    GOTO MAIN_MENU
)

SET /P "confirm=确认要继续吗？还原操作将覆盖当前开始菜单设置！(Y/N): "
IF /I NOT "%confirm%"=="Y" GOTO MAIN_MENU

ECHO.
ECHO 开始菜单还原进程:
ECHO ==================================================

rem 1. 关闭Windows资源管理器以释放锁定
ECHO [1/4] 正在关闭Windows资源管理器...
TASKKILL /F /IM explorer.exe >nul 2>&1

rem 2. 还原开始菜单文件夹
ECHO [2/4] 正在还原开始菜单文件夹...
IF EXIST "%restore_path%\Start Menu" (
    ROBOCOPY "%restore_path%\Start Menu" "%APPDATA%\Microsoft\Windows\Start Menu" /E /COPYALL /XJ /IS /IT /R:3 /W:5
    IF %ERRORLEVEL% GEQ 8 (
        ECHO 错误: 开始菜单文件夹还原失败！
    )
) ELSE (
    ECHO 警告: 未找到开始菜单文件夹备份！
)

rem 3. 还原开始菜单数据库
ECHO [3/4] 正在还原开始菜单数据库...
IF EXIST "%restore_path%\TileDataLayer\Database" (
    IF NOT EXIST "%LOCALAPPDATA%\TileDataLayer\Database" (
        MKDIR "%LOCALAPPDATA%\TileDataLayer\Database" >nul 2>&1
    )
    ROBOCOPY "%restore_path%\TileDataLayer\Database" "%LOCALAPPDATA%\TileDataLayer\Database" /E /COPYALL /XJ /IS /IT /R:3 /W:5
    IF %ERRORLEVEL% GEQ 8 (
        ECHO 错误: 开始菜单数据库还原失败！
    )
) ELSE (
    ECHO 警告: 未找到开始菜单数据库备份！
)

rem 4. 使用PowerShell还原开始菜单布局
ECHO [4/4] 正在使用PowerShell还原开始菜单布局...
IF EXIST "%restore_path%\StartLayout.xml" (
    PowerShell -Command "Import-StartLayout -LayoutPath '%restore_path%\StartLayout.xml' -MountPath 'C:\'" >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 警告: 开始菜单布局还原可能不完全成功！
    )
) ELSE (
    ECHO 警告: 未找到开始菜单布局备份文件！
)

rem 重启Windows资源管理器
ECHO 正在重启Windows资源管理器...
START explorer.exe

ECHO ==================================================
COLOR 2F
ECHO.
ECHO 开始菜单还原完成！
ECHO 请立即重启电脑以确保更改生效。
ECHO.
PAUSE
GOTO MAIN_MENU

:EXIT_PROGRAM
CLS
ECHO.
ECHO 感谢使用 %title%，再见！
ECHO.
PAUSE >nul
ENDLOCAL
exit /B 0

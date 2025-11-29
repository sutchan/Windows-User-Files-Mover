@ECHO off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

rem ==================================================
rem Windows User Files Mover - 用户文件迁移工具
rem 版本: v1.10.2
rem 作者: SutChan
rem 功能: 文件迁移与开始菜单备份还原
rem ==================================================

rem 配置区域 - 集中管理所有配置项
SET "CONFIG_VERSION=v1.10.2"
SET "CONFIG_AUTHOR=SutChan"
SET "CONFIG_TITLE=Windows User Files Mover 用户文件迁移工具"
SET "CONFIG_DEFAULT_TARGET_DRIVE=E:"
SET "CONFIG_PROJECT_URL=https://github.com/sutchan/Windows-User-Files-Mover"

rem 设置全局变量
SET "target_drive=%CONFIG_DEFAULT_TARGET_DRIVE%"
SET "LOG_FILE=%~dp0Windows_UserFiles_Mover.log"

rem 设置窗口标题
TITLE %CONFIG_TITLE% by %CONFIG_AUTHOR% Ver:%CONFIG_VERSION%

rem 创建日志文件（如果不存在）
IF NOT EXIST "%LOG_FILE%" (
    ECHO [%DATE% %TIME%] 日志文件已创建 > "%LOG_FILE%"
)

rem 检查系统兼容性
CALL :CHECK_COMPATIBILITY
IF %ERRORLEVEL% NEQ 0 (
    PAUSE >nul
    exit /B 1
)

rem 检查管理员权限
CALL :CHECK_ADMIN
IF %ERRORLEVEL% NEQ 0 (
    ECHO 错误: 需要管理员权限才能运行此程序！
    ECHO 请右键点击批处理文件，选择"以管理员身份运行"。
    PAUSE >nul
    exit /B 1
)

:MAIN_MENU
CLS
color e0

rem 显示标题和信息
CALL :DISPLAY_HEADER

ECHO.    [1] 执行文件迁移
ECHO.    [2] 开始菜单备份
ECHO.    [3] 开始菜单还原
ECHO.    [4] 显示操作日志
ECHO.    [0] 退出程序
ECHO.

rem 获取用户选择，增加输入验证
SET "choice="
SET /P "choice=请选择操作 (0-4): "

rem 验证用户输入
ECHO %choice% | FINDSTR /R "^[0-4]$" >nul
IF %ERRORLEVEL% NEQ 0 (
    ECHO 无效的选择，请输入0-4之间的数字。
    PAUSE >nul
    GOTO MAIN_MENU
)

IF "%choice%"=="0" GOTO EXIT_PROGRAM
IF "%choice%"=="1" GOTO MIGRATE
IF "%choice%"=="2" GOTO BACKUP_STARTMENU
IF "%choice%"=="3" GOTO RESTORE_STARTMENU
IF "%choice%"=="4" GOTO VIEW_LOG

GOTO MAIN_MENU

rem ==================================================
rem 函数: 记录日志信息
rem 参数: %1 - 日志消息
rem ==================================================
:LOG_MESSAGE
    SET "log_message=%~1"
    SET "timestamp=%DATE% %TIME%"
    ECHO [%timestamp%] %log_message%
    ECHO [%timestamp%] %log_message% >> "%LOG_FILE%"
GOTO :EOF

rem ==================================================
rem 函数: 显示标题信息
rem ==================================================
:DISPLAY_HEADER
    ECHO.    ┏=========================================┓
    ECHO.        【 %CONFIG_TITLE% 】
    ECHO.    
    ECHO.        作者  : %CONFIG_AUTHOR%
    ECHO.        版本  : %CONFIG_VERSION%
    ECHO.        项目地址: %CONFIG_PROJECT_URL%
    ECHO.    ┗=========================================┛
GOTO :EOF

rem ==================================================
rem 函数: 检查系统兼容性
rem ==================================================
:CHECK_COMPATIBILITY
    rem 检查Windows版本
    VER | FINDSTR /I "Windows" >nul
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 错误: 此工具仅适用于Windows操作系统！
        EXIT /B 1
    )
    
    rem 检查ROBOCOPY命令是否可用
    WHERE ROBOCOPY >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 错误: 系统缺少ROBOCOPY命令，无法执行文件迁移操作！
        EXIT /B 1
    )
    
    rem 检查PowerShell是否可用
    WHERE PowerShell >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        ECHO 警告: 系统缺少PowerShell，开始菜单备份/还原功能可能不可用！
    )
EXIT /B 0

rem ==================================================
rem 函数: 检查管理员权限
rem ==================================================
:CHECK_ADMIN
    NET SESSION >nul 2>&1
EXIT /B %ERRORLEVEL%

rem ==================================================
rem 函数: 获取可靠的时间戳
rem ==================================================
:GET_TIMESTAMP
    FOR /F "tokens=2 delims==." %%G IN ('WMIC OS GET LocalDateTime /VALUE') DO (
        SET "timestamp=%%G"
    )
    SET "timestamp=%timestamp:~0,4%%timestamp:~4,2%%timestamp:~6,2%_%timestamp:~8,2%%timestamp:~10,2%%timestamp:~12,2%"
GOTO :EOF

rem ==================================================
rem 函数: 迁移文件夹并创建链接
rem 参数: %1 - 源文件夹路径
rem       %2 - 目标文件夹路径
rem ==================================================
:MIGRATE_FOLDER
    SET "source_folder=%~1"
    SET "target_folder=%~2"
    SET "folder_name=%~nx1"
    SET "operation_success=true"
    
    CALL :LOG_MESSAGE "开始处理: %folder_name%"
    ECHO.
    ECHO [处理] %folder_name%
    
    rem 检查源文件夹是否存在
    IF NOT EXIST "%source_folder%" (
        CALL :LOG_MESSAGE "警告: 源文件夹不存在，跳过 - %source_folder%"
        ECHO 警告: 源文件夹不存在，跳过 - %source_folder%
        GOTO :EOF
    )
    
    rem 检查目标驱动器是否存在
    FOR %%D IN (%target_drive%) DO (
        IF NOT EXIST "%%D" (
            CALL :LOG_MESSAGE "错误: 目标驱动器不存在 - %target_drive%"
            ECHO 错误: 目标驱动器不存在 - %target_drive%
            SET "operation_success=false"
            GOTO :EOF
        )
    )
    
    rem 检查目标驱动器剩余空间
    CALL :CHECK_DISK_SPACE "%target_drive%"
    IF %ERRORLEVEL% NEQ 0 (
        SET "operation_success=false"
        GOTO :EOF
    )
    
    rem 创建目标文件夹（包括父目录）
    FOR %%I IN ("%target_folder%") DO (
        IF NOT EXIST "%%~dpI" (
            CALL :LOG_MESSAGE "创建目标文件夹: %%~dpI"
            MKDIR "%%~dpI" >nul 2>&1
            IF !ERRORLEVEL! NEQ 0 (
                CALL :LOG_MESSAGE "错误: 无法创建目标文件夹 - %%~dpI"
                ECHO 错误: 无法创建目标文件夹 - %%~dpI
                SET "operation_success=false"
                GOTO :EOF
            )
        )
    )
    
    rem 复制文件 - 优化ROBOCOPY参数
    ECHO 正在复制文件...
    CALL :LOG_MESSAGE "开始复制文件: %source_folder% -> %target_folder%"
    ROBOCOPY "%source_folder%" "%target_folder%" /E /COPYALL /XJ /R:2 /W:5 /MT:8 /NP
    IF !ERRORLEVEL! GEQ 8 (
        CALL :LOG_MESSAGE "错误: 文件复制失败！错误代码: !ERRORLEVEL!"
        ECHO 错误: 文件复制失败！
        SET "operation_success=false"
        GOTO :EOF
    )
    
    rem 备份并删除源文件夹
    ECHO 正在创建链接...
    CALL :LOG_MESSAGE "准备创建目录链接: %source_folder% -> %target_folder%"
    
    rem 先检查是否已经存在链接
    DIR /AL "%source_folder%" >nul 2>&1
    IF !ERRORLEVEL! EQU 0 (
        CALL :LOG_MESSAGE "警告: 源文件夹已经是链接，删除旧链接"
        RMDIR "%source_folder%" >nul 2>&1
    )
    
    IF EXIST "%source_folder%.backup" (
        CALL :LOG_MESSAGE "删除旧的备份文件夹: %source_folder%.backup"
        RMDIR "%source_folder%.backup" /S /Q >nul 2>&1
    )
    
    IF EXIST "%source_folder%" (
        RENAME "%source_folder%" "%folder_name%.backup" >nul 2>&1
        IF !ERRORLEVEL! NEQ 0 (
            CALL :LOG_MESSAGE "警告: 无法重命名源文件夹，尝试强制删除"
            ECHO 警告: 无法重命名源文件夹，尝试强制删除
            RMDIR "%source_folder%" /S /Q >nul 2>&1
            IF !ERRORLEVEL! NEQ 0 (
                CALL :LOG_MESSAGE "错误: 无法删除源文件夹，操作失败！"
                ECHO 错误: 无法删除源文件夹，操作失败！
                SET "operation_success=false"
                GOTO :EOF
            )
        )
    )
    
    rem 创建目录链接
    MKLINK /J "%source_folder%" "%target_folder%" >nul 2>&1
    IF !ERRORLEVEL! NEQ 0 (
        CALL :LOG_MESSAGE "错误: 无法创建目录链接！"
        ECHO 错误: 无法创建目录链接！
        rem 尝试恢复源文件夹
        IF EXIST "%source_folder%.backup" (
            CALL :LOG_MESSAGE "尝试恢复源文件夹"
            RENAME "%source_folder%.backup" "%folder_name%" >nul 2>&1
        )
        SET "operation_success=false"
        GOTO :EOF
    )
    
    rem 删除备份
    IF EXIST "%source_folder%.backup" (
        CALL :LOG_MESSAGE "删除备份文件夹: %source_folder%.backup"
        RMDIR "%source_folder%.backup" /S /Q >nul 2>&1
    )
    
    CALL :LOG_MESSAGE "完成处理: %folder_name%"
    ECHO [完成] %folder_name%
GOTO :EOF

rem ==================================================
rem 函数: 检查磁盘空间
rem 参数: %1 - 驱动器路径
rem ==================================================
:CHECK_DISK_SPACE
    SET "drive=%~1"
    
    rem 获取磁盘剩余空间（单位：字节）
    FOR /F "tokens=3" %%S IN ('dir %drive% ^| findstr /C:"可用字节"') DO (
        SET "free_space=%%S"
    )
    
    rem 移除千位分隔符
    SET "free_space=%free_space:,=%"
    
    rem 检查是否有至少5GB可用空间
    IF %free_space% LSS 5368709120 (
        CALL :LOG_MESSAGE "警告: 目标驱动器空间不足，建议至少有5GB可用空间"
        ECHO 警告: 目标驱动器空间不足，建议至少有5GB可用空间
        ECHO 继续操作可能导致迁移失败，是否继续？
        CHOICE /C YN /M "请选择: "
        IF %ERRORLEVEL% EQU 2 (
            CALL :LOG_MESSAGE "用户取消操作: 磁盘空间不足"
            EXIT /B 1
        )
    )
EXIT /B 0

rem ==================================================
rem 函数: 清理临时文件夹
rem ==================================================
:CLEAN_TEMP_FOLDERS
    ECHO.
    ECHO 正在清理临时文件夹...
    CALL :LOG_MESSAGE "开始清理临时文件夹"
    
    rem 定义临时文件夹列表
    SET "temp_folders="
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Local\TEMP"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\Vidown"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\VTWAFDI"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\Wandoujia"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\Sierra Wireless"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\LDSGameAssistant"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\WNS"
    SET "temp_folders=%temp_folders%;%USERPROFILE%\AppData\Roaming\wps"
    
    rem 使用for循环处理列表
    FOR %%F IN (%temp_folders:;= %) DO (
        IF EXIST "%%F" (
            CALL :LOG_MESSAGE "清理临时文件夹: %%F"
            ECHO 清理: %%F
            RMDIR "%%F" /S /Q >nul 2>&1
            IF !ERRORLEVEL! NEQ 0 (
                CALL :LOG_MESSAGE "警告: 无法完全清理临时文件夹: %%F"
                ECHO 警告: 无法完全清理临时文件夹: %%F
            )
        )
    )
    
    CALL :LOG_MESSAGE "临时文件夹清理完成"
GOTO :EOF

rem ==================================================
rem 函数: 显示操作日志
rem ==================================================
:VIEW_LOG
    CLS
    ECHO.    ┏=========================================┓
    ECHO.        【 操作日志查看 】
    ECHO.    ┗=========================================┛
    ECHO.
    
    IF NOT EXIST "%LOG_FILE%" (
        ECHO 暂无操作日志。
        ECHO.
        PAUSE >nul
        GOTO MAIN_MENU
    )
    
    ECHO 最近的操作日志:
    ECHO ------------------------------------------
    rem 显示最近50行日志
    MORE +%=(TYPE "%LOG_FILE%" | FIND /C /V "" ^& ECHO 50) -50" %LOG_FILE% | MORE
    ECHO ------------------------------------------
    ECHO.
    ECHO 日志文件位置: %LOG_FILE%
    ECHO.
    
    CHOICE /C VX /M "[V] 查看完整日志  [X] 返回菜单: "
    IF %ERRORLEVEL% EQU 1 (
        NOTEPAD "%LOG_FILE%"
    )
    
    GOTO MAIN_MENU

:MIGRATE
CLS
ECHO.
ECHO ==================================================
ECHO         文件迁移功能
ECHO ==================================================
ECHO 此功能将用户文件从系统盘迁移到其他分区，并创建目录链接。
ECHO 警告: 请确保目标驱动器有足够空间，操作前建议备份重要数据！
ECHO.

rem 获取目标驱动器，增加输入验证
:GET_TARGET_DRIVE
    SET "custom_drive="
    SET /P "custom_drive=请输入目标驱动器 (默认为 %target_drive%, 直接按回车使用默认值): "
    
    IF NOT "%custom_drive%"=="" (
        rem 验证驱动器格式
        ECHO %custom_drive% | FINDSTR /R "^[A-Za-z]:" >nul
        IF %ERRORLEVEL% NEQ 0 (
            ECHO 错误: 驱动器格式不正确，请使用如 "D:" 这样的格式。
            GOTO GET_TARGET_DRIVE
        )
        SET "target_drive=%custom_drive:~0,2%"
    )

ECHO.
ECHO 目标驱动器: %target_drive%
ECHO.

rem 使用CHOICE命令替代SET /P，提高用户体验
CHOICE /C YN /M "确认要继续吗？(此操作可能需要较长时间)" 
IF %ERRORLEVEL% EQU 2 GOTO MAIN_MENU

CALL :LOG_MESSAGE "开始文件迁移流程，目标驱动器: %target_drive%"

CALL :CLEAN_TEMP_FOLDERS

rem 定义要迁移的文件夹列表 - 使用数组方式管理
SET "migrate_list[0]=%USERPROFILE%\AppData\Local\Google|%target_drive%\Users\Admin\AppData\Local\Google"
SET "migrate_list[1]=%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth|%target_drive%\Dropbox\My\Google\GoogleEarth"
SET "migrate_list[2]=%USERPROFILE%\AppData\Local\Adobe|%target_drive%\Users\Admin\AppData\Local\Adobe"
SET "migrate_list[3]=%USERPROFILE%\AppData\Local\Apple Computer|%target_drive%\Users\Admin\AppData\Local\Apple Computer"
SET "migrate_list[4]=%USERPROFILE%\AppData\Roaming\Apple Computer|%target_drive%\Users\Admin\AppData\Roaming\Apple Computer"
SET "migrate_list[5]=%USERPROFILE%\AppData\Local\Wandoujia2|%target_drive%\Users\Admin\AppData\Local\Wandoujia2"
SET "migrate_list[6]=%USERPROFILE%\AppData\Roaming\Wandoujia2|%target_drive%\Users\Admin\AppData\Roaming\Wandoujia2"
SET "migrate_list[7]=%USERPROFILE%\AppData\Roaming\Winamp|%target_drive%\Users\Admin\AppData\Roaming\Winamp"
SET "migrate_list[8]=%USERPROFILE%\AppData\Roaming\ytmediacenter|%target_drive%\Users\Admin\AppData\Roaming\ytmediacenter"
SET "migrate_list[9]=%USERPROFILE%\AppData\Local\Yodao|%target_drive%\Users\Admin\AppData\Local\Yodao"
SET "migrate_list[10]=%USERPROFILE%\AppData\Local\aef|%target_drive%\Users\Admin\AppData\Local\aef"
SET "migrate_list[11]=%USERPROFILE%\AppData\Local\Netease|%target_drive%\Users\Admin\AppData\Local\Netease"
SET "migrate_list[12]=%USERPROFILE%\AppData\LocalLow\SogouPY|%target_drive%\Users\Admin\AppData\LocalLow\SogouPY"
SET "migrate_list[13]=%USERPROFILE%\AppData\LocalLow\SogouPY.users|%target_drive%\Users\Admin\AppData\LocalLow\SogouPY.users"
SET "migrate_list[14]=%USERPROFILE%\AppData\Roaming\5kplayer|%target_drive%\Users\Admin\AppData\Roaming\5kplayer"
SET "migrate_list[15]=%USERPROFILE%\AppData\Roaming\Adobe|%target_drive%\Users\Admin\AppData\Roaming\Adobe"
SET "migrate_list[16]=%USERPROFILE%\AppData\Roaming\SketchUp|%target_drive%\Users\Admin\AppData\Roaming\SketchUp"
SET "migrate_list[17]=%USERPROFILE%\AppData\Roaming\Teiron|%target_drive%\Users\Admin\AppData\Roaming\Teiron"
SET "migrate_list[18]=%USERPROFILE%\AppData\Roaming\Kingsoft|%target_drive%\Users\Admin\AppData\Roaming\Kingsoft"
SET "migrate_list[19]=%USERPROFILE%\AppData\Roaming\Lantern|%target_drive%\Users\Admin\AppData\Roaming\Lantern"
SET "migrate_list[20]=%USERPROFILE%\AppData\Roaming\Tencent|%target_drive%\Users\Admin\AppData\Roaming\Tencent"
SET "migrate_list[21]=%USERPROFILE%\AppData\Roaming\Thea Render|%target_drive%\Users\Admin\AppData\Roaming\Thea Render"
SET "migrate_list[22]=%USERPROFILE%\AppData\Roaming\youku|%target_drive%\Users\Admin\AppData\Roaming\youku"
SET "migrate_list[23]=%USERPROFILE%\AppData\Local\Microsoft|%target_drive%\Users\Admin\AppData\Local\Microsoft"
SET "migrate_list[24]=%USERPROFILE%\AppData\Local\Comms|%target_drive%\Users\Admin\AppData\Local\Comms"

ECHO.
ECHO 开始迁移文件...
ECHO ==================================================

rem 获取迁移总数
SET "migrate_count=0"
FOR /F "tokens=2 delims==[]" %%I IN ('SET migrate_list[') DO (
    SET /A "migrate_count+=1"
)

SET "current_migrate=0"
SET "success_count=0"
SET "failed_count=0"

rem 遍历迁移列表
FOR /F "tokens=2 delims==[]" %%I IN ('SET migrate_list[') DO (
    SET /A "current_migrate+=1"
    
    rem 分割源路径和目标路径
    FOR /F "tokens=1,2 delims=|" %%A IN ("%%I") DO (
        ECHO [进度: %current_migrate%/%migrate_count%] 准备迁移: %%~nxA
        CALL :MIGRATE_FOLDER "%%A" "%%B"
        
        rem 检查操作是否成功
        IF "!operation_success!"=="true" (
            SET /A "success_count+=1"
        ) ELSE (
            SET /A "failed_count+=1"
        )
    )
)

ECHO ==================================================
COLOR 2F
ECHO.
CALL :LOG_MESSAGE "文件迁移完成 - 成功: %success_count%, 失败: %failed_count%"
ECHO 操作已完成！
ECHO 成功迁移: %success_count% 个文件夹
ECHO 迁移失败: %failed_count% 个文件夹
ECHO 感谢你使用 %CONFIG_TITLE%！
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

rem 检查PowerShell是否可用
WHERE PowerShell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO 错误: 系统缺少PowerShell，无法执行开始菜单备份操作！
    PAUSE >nul
    GOTO MAIN_MENU
)

SET "default_backup_path=%CD%\StartMenu_Backups"
SET "backup_path="
SET /P "backup_path=请选择备份目标路径 (默认为 %default_backup_path%): "
IF "%backup_path%"=="" SET "backup_path=%default_backup_path%"

rem 检查备份路径是否存在，不存在则创建
IF NOT EXIST "%backup_path%" (
    CALL :LOG_MESSAGE "创建备份根目录: %backup_path%"
    MKDIR "%backup_path%" >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        CALL :LOG_MESSAGE "错误: 无法创建备份路径！"
        ECHO 错误: 无法创建备份路径！
        PAUSE
        GOTO MAIN_MENU
    )
)

rem 创建带可靠时间戳的备份目录
CALL :GET_TIMESTAMP
SET "backup_dir=%backup_path%\StartMenu_Backup_%timestamp%"

ECHO.
ECHO 正在创建备份目录: %backup_dir%
CALL :LOG_MESSAGE "创建备份目录: %backup_dir%"
MKDIR "%backup_dir%" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    CALL :LOG_MESSAGE "错误: 无法创建备份目录！"
    ECHO 错误: 无法创建备份目录！
    PAUSE
    GOTO MAIN_MENU
)

rem 创建备份信息文件
ECHO Windows开始菜单备份信息 > "%backup_dir%\BACKUP_INFO.txt"
ECHO 备份时间: %DATE% %TIME% >> "%backup_dir%\BACKUP_INFO.txt"
ECHO 备份工具版本: %CONFIG_VERSION% >> "%backup_dir%\BACKUP_INFO.txt"
ECHO Windows版本: %OS% >> "%backup_dir%\BACKUP_INFO.txt"

ECHO.
ECHO 开始菜单备份进程:
ECHO ==================================================

SET "backup_success=true"

rem 1. 使用PowerShell备份开始菜单布局
ECHO [1/3] 正在使用PowerShell备份开始菜单布局...
CALL :LOG_MESSAGE "开始备份开始菜单布局"
PowerShell -Command "Export-StartLayout -Path '%backup_dir%\StartLayout.xml'" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    CALL :LOG_MESSAGE "警告: 开始菜单布局备份可能不完全成功！"
    ECHO 警告: 开始菜单布局备份可能不完全成功！
    SET "backup_success=false"
)

rem 2. 备份开始菜单文件夹
ECHO [2/3] 正在备份开始菜单文件夹...
CALL :LOG_MESSAGE "开始备份开始菜单文件夹"
ROBOCOPY "%APPDATA%\Microsoft\Windows\Start Menu" "%backup_dir%\Start Menu" /E /COPYALL /XJ /R:2 /W:3 /MT:4 /NP
IF %ERRORLEVEL% GEQ 8 (
    CALL :LOG_MESSAGE "错误: 开始菜单文件夹备份失败！"
    ECHO 错误: 开始菜单文件夹备份失败！
    SET "backup_success=false"
)

rem 3. 备份开始菜单数据库
ECHO [3/3] 正在备份开始菜单数据库...
CALL :LOG_MESSAGE "开始备份开始菜单数据库"
IF EXIST "%LOCALAPPDATA%\TileDataLayer\Database" (
    MKDIR "%backup_dir%\TileDataLayer\Database" >nul 2>&1
    ROBOCOPY "%LOCALAPPDATA%\TileDataLayer\Database" "%backup_dir%\TileDataLayer\Database" /E /COPYALL /XJ /R:2 /W:3 /MT:4 /NP
    IF %ERRORLEVEL% GEQ 8 (
        CALL :LOG_MESSAGE "错误: 开始菜单数据库备份失败！"
        ECHO 错误: 开始菜单数据库备份失败！
        SET "backup_success=false"
    )
) ELSE (
    CALL :LOG_MESSAGE "信息: 未找到开始菜单数据库，跳过此步骤。"
    ECHO 信息: 未找到开始菜单数据库，跳过此步骤。
)

ECHO ==================================================

rem 根据备份结果设置不同颜色
IF "%backup_success%"=="true" (
    COLOR 2F
    CALL :LOG_MESSAGE "开始菜单备份成功完成"
) ELSE (
    COLOR 4F
    CALL :LOG_MESSAGE "开始菜单备份完成，但有部分操作失败"
)

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

rem 检查PowerShell是否可用
WHERE PowerShell >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO 错误: 系统缺少PowerShell，无法执行开始菜单还原操作！
    PAUSE >nul
    GOTO MAIN_MENU
)

:GET_RESTORE_PATH
SET "restore_path="
SET /P "restore_path=请输入备份文件所在路径: "

IF "%restore_path%"=="" (
    ECHO 错误: 备份路径不能为空！
    GOTO GET_RESTORE_PATH
)

IF NOT EXIST "%restore_path%" (
    CALL :LOG_MESSAGE "错误: 备份路径不存在！"
    ECHO 错误: 备份路径不存在！
    PAUSE
    GOTO MAIN_MENU
)

rem 验证备份路径是否包含必要的文件
SET "has_menu_folder=false"
SET "has_database=false"
SET "has_layout=false"

IF EXIST "%restore_path%\Start Menu" SET "has_menu_folder=true"
IF EXIST "%restore_path%\TileDataLayer\Database" SET "has_database=true"
IF EXIST "%restore_path%\StartLayout.xml" SET "has_layout=true"

rem 如果没有找到任何备份文件，提示用户
IF NOT %has_menu_folder% EQU true IF NOT %has_database% EQU true IF NOT %has_layout% EQU true (
    CALL :LOG_MESSAGE "错误: 选择的路径不包含有效的开始菜单备份文件！"
    ECHO 错误: 选择的路径不包含有效的开始菜单备份文件！
    PAUSE
    GOTO MAIN_MENU
)

rem 显示找到的备份内容
ECHO.
ECHO 检测到备份内容:
IF %has_menu_folder% EQU true ECHO - 开始菜单文件夹
IF %has_database% EQU true ECHO - 开始菜单数据库
IF %has_layout% EQU true ECHO - 开始菜单布局文件
ECHO.

rem 使用CHOICE命令替代SET /P
CHOICE /C YN /M "确认要继续吗？还原操作将覆盖当前开始菜单设置！" 
IF %ERRORLEVEL% EQU 2 GOTO MAIN_MENU

CALL :LOG_MESSAGE "开始还原开始菜单，备份路径: %restore_path%"

ECHO.
ECHO 开始菜单还原进程:
ECHO ==================================================

SET "restore_success=true"

rem 1. 关闭Windows资源管理器以释放锁定
ECHO [1/4] 正在关闭Windows资源管理器...
CALL :LOG_MESSAGE "关闭Windows资源管理器以释放锁定"
TASKKILL /F /IM explorer.exe >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    CALL :LOG_MESSAGE "警告: 关闭Windows资源管理器失败，但继续尝试还原"
    ECHO 警告: 关闭Windows资源管理器失败，但继续尝试还原
)

rem 等待资源管理器完全关闭
TIMEOUT /T 2 /NOBREAK >nul

rem 2. 还原开始菜单文件夹
ECHO [2/4] 正在还原开始菜单文件夹...
IF %has_menu_folder% EQU true (
    CALL :LOG_MESSAGE "开始还原开始菜单文件夹"
    rem 先备份当前开始菜单文件夹
    IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu.old" (
        RMDIR "%APPDATA%\Microsoft\Windows\Start Menu.old" /S /Q >nul 2>&1
    )
    IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu" (
        RENAME "%APPDATA%\Microsoft\Windows\Start Menu" "Start Menu.old" >nul 2>&1
    )
    
    ROBOCOPY "%restore_path%\Start Menu" "%APPDATA%\Microsoft\Windows\Start Menu" /E /COPYALL /XJ /R:2 /W:3 /MT:4 /NP
    IF %ERRORLEVEL% GEQ 8 (
        CALL :LOG_MESSAGE "错误: 开始菜单文件夹还原失败！"
        ECHO 错误: 开始菜单文件夹还原失败！
        SET "restore_success=false"
    )
) ELSE (
    ECHO 跳过: 未找到开始菜单文件夹备份！
)

rem 3. 还原开始菜单数据库
ECHO [3/4] 正在还原开始菜单数据库...
IF %has_database% EQU true (
    CALL :LOG_MESSAGE "开始还原开始菜单数据库"
    rem 先备份当前数据库
    IF EXIST "%LOCALAPPDATA%\TileDataLayer\Database.old" (
        RMDIR "%LOCALAPPDATA%\TileDataLayer\Database.old" /S /Q >nul 2>&1
    )
    IF EXIST "%LOCALAPPDATA%\TileDataLayer\Database" (
        RENAME "%LOCALAPPDATA%\TileDataLayer\Database" "Database.old" >nul 2>&1
    )
    
    IF NOT EXIST "%LOCALAPPDATA%\TileDataLayer\Database" (
        MKDIR "%LOCALAPPDATA%\TileDataLayer\Database" >nul 2>&1
    )
    ROBOCOPY "%restore_path%\TileDataLayer\Database" "%LOCALAPPDATA%\TileDataLayer\Database" /E /COPYALL /XJ /R:2 /W:3 /MT:4 /NP
    IF %ERRORLEVEL% GEQ 8 (
        CALL :LOG_MESSAGE "错误: 开始菜单数据库还原失败！"
        ECHO 错误: 开始菜单数据库还原失败！
        SET "restore_success=false"
    )
) ELSE (
    ECHO 跳过: 未找到开始菜单数据库备份！
)

rem 4. 使用PowerShell还原开始菜单布局
ECHO [4/4] 正在使用PowerShell还原开始菜单布局...
IF %has_layout% EQU true (
    CALL :LOG_MESSAGE "开始还原开始菜单布局"
    PowerShell -Command "Import-StartLayout -LayoutPath '%restore_path%\StartLayout.xml' -MountPath 'C:\'" >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        CALL :LOG_MESSAGE "警告: 开始菜单布局还原可能不完全成功！"
        ECHO 警告: 开始菜单布局还原可能不完全成功！
        SET "restore_success=false"
    )
) ELSE (
    ECHO 跳过: 未找到开始菜单布局备份文件！
)

rem 重启Windows资源管理器
ECHO 正在重启Windows资源管理器...
CALL :LOG_MESSAGE "重启Windows资源管理器"
START explorer.exe

ECHO ==================================================

rem 根据还原结果设置不同颜色
IF "%restore_success%"=="true" (
    COLOR 2F
    CALL :LOG_MESSAGE "开始菜单还原成功完成"
) ELSE (
    COLOR 4F
    CALL :LOG_MESSAGE "开始菜单还原完成，但有部分操作失败"
)

ECHO.
ECHO 开始菜单还原完成！
ECHO 请立即重启电脑以确保更改生效。
ECHO.

rem 提供重启选项
CHOICE /C R X /M "[R] 立即重启电脑  [X] 稍后手动重启: "
IF %ERRORLEVEL% EQU 1 (
    CALL :LOG_MESSAGE "用户选择立即重启电脑"
    SHUTDOWN /R /T 10 /C "开始菜单还原完成，系统将在10秒后重启。"
)

PAUSE
GOTO MAIN_MENU

:EXIT_PROGRAM
CLS
CALL :LOG_MESSAGE "用户退出程序"
ECHO.
ECHO 感谢使用 %CONFIG_TITLE%，再见！
ECHO.
PAUSE >nul
ENDLOCAL
exit /B 0

@ECHO	off
rem 设置环境变量
SET build=20160429
SET author=Tanox
SET title=Windows User Files Mover 用户文件迁移工具


TITLE %title% by %author% Ver:%build%

color e0
ECHO	┏					┓
ECHO		【 %title% 】
ECHO.
ECHO		Author  : %author%
ECHO		Contact : xepinchan@qq.com
ECHO		Building: %build%
ECHO	┗					┛

PAUSE

REM ROBOCOPY "C:\Users" "E:\Users" /E /COPYALL /XJ    
REM RMDIR "C:\Users" /S /Q    
REM MKLINK /J "C:\Users" "E:\Users"

RMDIR "%USERPROFILE%\AppData\Local\TEMP" /S /Q 
RMDIR "%USERPROFILE%\AppData\Roaming\Vidown" /S /Q 
RMDIR "%USERPROFILE%\AppData\Roaming\VTWAFDI" /S /Q 
RMDIR "%USERPROFILE%\AppData\Roaming\Wandoujia" /S /Q 
RMDIR "%USERPROFILE%\AppData\Roaming\Sierra Wireless" /S /Q
RMDIR "%USERPROFILE%\AppData\Roaming\LDSGameAssistant" /S /Q 
RMDIR "%USERPROFILE%\AppData\Roaming\WNS" /S /Q 
RMDIR "%USERPROFILE%\AppData\Roaming\wps" /S /Q 

MKDIR "E:\Users\Admin\AppData\Local\Google"
ROBOCOPY "%USERPROFILE%\AppData\Local\Google" "E:\Users\Admin\AppData\Local\Google" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Google" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Google" "E:\Users\Admin\AppData\Local\Google"

MKDIR "E:\Dropbox\My\Google\GoogleEarth"
ROBOCOPY "%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth" "E:\Dropbox\My\Google\GoogleEarth" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth" /S /Q
MKLINK /J "%USERPROFILE%\AppData\LocalLow\Google\GoogleEarth" "E:\Dropbox\My\Google\GoogleEarth"

MKDIR "E:\Users\Admin\AppData\Local\Adobe"
ROBOCOPY "%USERPROFILE%\AppData\Local\Adobe" "E:\Users\Admin\AppData\Local\Adobe" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Adobe" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Adobe" "E:\Users\Admin\AppData\Local\Adobe"

MKDIR "E:\Users\Admin\AppData\Local\Apple Computer"
ROBOCOPY "%USERPROFILE%\AppData\Local\Apple Computer" "E:\Users\Admin\AppData\Local\Apple Computer" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Apple Computer" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Apple Computer" "E:\Users\Admin\AppData\Local\Apple Computer"

MKDIR "E:\Users\Admin\AppData\Roaming\Apple Computer"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Apple Computer" "E:\Users\Admin\AppData\Roaming\Apple Computer" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Apple Computer" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Apple Computer" "E:\Users\Admin\AppData\Roaming\Apple Computer"

MKDIR "E:\Users\Admin\AppData\Local\Wandoujia2"
ROBOCOPY "%USERPROFILE%\AppData\Local\Wandoujia2" "E:\Users\Admin\AppData\Local\Wandoujia2" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Wandoujia2" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Wandoujia2" "E:\Users\Admin\AppData\Local\Wandoujia2"

MKDIR "E:\Users\Admin\AppData\Roaming\Wandoujia2"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Wandoujia2" "E:\Users\Admin\AppData\Roaming\Wandoujia2" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Wandoujia2" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Wandoujia2" "E:\Users\Admin\AppData\Roaming\Wandoujia2"

MKDIR "E:\Users\Admin\AppData\Roaming\Winamp"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Winamp" "E:\Users\Admin\AppData\Roaming\Winamp" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Winamp" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Winamp" "E:\Users\Admin\AppData\Roaming\Winamp"


MKDIR "E:\Users\Admin\AppData\Roaming\ytmediacenter"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\ytmediacenter" "E:\Users\Admin\AppData\Roaming\ytmediacenter" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\ytmediacenter" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\ytmediacenter" "E:\Users\Admin\AppData\Roaming\ytmediacenter"

MKDIR "E:\Users\Admin\AppData\Local\Yodao"
ROBOCOPY "%USERPROFILE%\AppData\Local\Yodao" "E:\Users\Admin\AppData\Local\Yodao" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Yodao" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Yodao" "E:\Users\Admin\AppData\Local\Yodao"

MKDIR "E:\Users\Admin\AppData\Local\aef"
ROBOCOPY "%USERPROFILE%\AppData\Local\aef" "E:\Users\Admin\AppData\Local\aef" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\aef" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\aef" "E:\Users\Admin\AppData\Local\aef"



MKDIR "E:\Users\Admin\AppData\Local\Netease"
ROBOCOPY "%USERPROFILE%\AppData\Local\Netease" "E:\Users\Admin\AppData\Local\Netease" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Netease" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Netease" "E:\Users\Admin\AppData\Local\Netease"

MKDIR "E:\Users\Admin\AppData\LocalLow\SogouPY"
ROBOCOPY "%USERPROFILE%\AppData\LocalLow\SogouPY" "E:\Users\Admin\AppData\LocalLow\SogouPY" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\LocalLow\SogouPY" /S /Q
MKLINK /J "%USERPROFILE%\AppData\LocalLow\SogouPY" "E:\Users\Admin\AppData\LocalLow\SogouPY"

MKDIR "E:\Users\Admin\AppData\LocalLow\SogouPY.users"
ROBOCOPY "%USERPROFILE%\AppData\LocalLow\SogouPY.users" "E:\Users\Admin\AppData\LocalLow\SogouPY.users" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\LocalLow\SogouPY.users" /S /Q
MKLINK /J "%USERPROFILE%\AppData\LocalLow\SogouPY.users" "E:\Users\Admin\AppData\LocalLow\SogouPY.users"

ROBOCOPY "%USERPROFILE%\AppData\Roaming\5kplayer" "E:\Users\Admin\AppData\Roaming\5kplayer" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\5kplayer" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\5kplayer" "E:\Users\Admin\AppData\Roaming\5kplayer"

MKDIR "E:\Users\Admin\AppData\Roaming\Adobe"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Adobe" "E:\Users\Admin\AppData\Roaming\Adobe" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Adobe" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Adobe" "E:\Users\Admin\AppData\Roaming\Adobe"

MKDIR "E:\Users\Admin\AppData\Roaming\SketchUp"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\SketchUp" "E:\Users\Admin\AppData\Roaming\SketchUp" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\SketchUp" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\SketchUp" "E:\Users\Admin\AppData\Roaming\SketchUp"

MKDIR "E:\Users\Admin\AppData\Roaming\Teiron"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Teiron" "E:\Users\Admin\AppData\Roaming\Teiron" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Teiron" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Teiron" "E:\Users\Admin\AppData\Roaming\Teiron"

MKDIR "E:\Users\Admin\AppData\Roaming\Kingsoft"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Kingsoft" "E:\Users\Admin\AppData\Roaming\Kingsoft" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Kingsoft" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Kingsoft" "E:\Users\Admin\AppData\Roaming\Kingsoft"

MKDIR "E:\Users\Admin\AppData\Roaming\Lantern"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Lantern" "E:\Users\Admin\AppData\Roaming\Lantern" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Lantern" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Lantern" "E:\Users\Admin\AppData\Roaming\Lantern"

MKDIR E:\Users\Admin\AppData\Roaming\Tencent"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Tencent" "E:\Users\Admin\AppData\Roaming\Tencent" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Tencent" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Tencent" "E:\Users\Admin\AppData\Roaming\Tencent"

MKDIR "E:\Users\Admin\AppData\Roaming\Thea Render"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\Thea Render" "E:\Users\Admin\AppData\Roaming\Thea Render" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\Thea Render" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\Thea Render" "E:\Users\Admin\AppData\Roaming\Thea Render"

MKDIR "E:\Users\Admin\AppData\Roaming\youku"
ROBOCOPY "%USERPROFILE%\AppData\Roaming\youku" "E:\Users\Admin\AppData\Roaming\youku" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Roaming\youku" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Roaming\youku" "E:\Users\Admin\AppData\Roaming\youku"


MKDIR "E:\Users\Admin\AppData\Local\Microsoft"
ROBOCOPY "%USERPROFILE%\AppData\Local\Microsoft" "E:\Users\Admin\AppData\Local\Microsoft" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Microsoft" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Microsoft" "E:\Users\Admin\AppData\Local\Microsoft"

MKDIR "E:\Users\Admin\AppData\Local\Comms"
ROBOCOPY "%USERPROFILE%\AppData\Local\Comms" "E:\Users\Admin\AppData\Local\Comms" /E /COPYALL /XJ  
RMDIR "%USERPROFILE%\AppData\Local\Comms" /S /Q
MKLINK /J "%USERPROFILE%\AppData\Local\Comms" "E:\Users\Admin\AppData\Local\Comms"


COLOR 2F
ECHO.
ECHO	操作已完成, 感谢你使用 %title%！

PAUSE

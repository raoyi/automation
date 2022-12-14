@echo off
TITLE CopyTool-v0.1
:start
ipconfig | find "100.101." > nul
if ERRORLEVEL 0 goto mappreload
ipconfig | find "192.168." > nul
if ERRORLEVEL 0 goto mapoffice
echo connect the network and continue...
pause
goto start

:mappreload
net use T: \\100.101.16.2\sxtesttool /user:administrator sx=123 /PERSISTENT:NO
rem explorer T:\
if ERRORLEVEL 0 goto cpchoice
timeout 3
goto mappreload

:mapoffice
net use T: \\192.168.0.10\sxtesttool /user:administrator sx=123 /PERSISTENT:NO
rem explorer T:\
if ERRORLEVEL 0 goto cpchoice
timeout 3
goto mapoffice

:cpchoice
echo 1. copy stress tools
echo 2. copy performance tools
echo 3. copy all tools
choice /C 123
if ERRORLEVEL 1 goto cpstress
if ERRORLEVEL 2 goto cpperformance
if ERRORLEVEL 3 goto cpall
goto end

:cpstress
xcopy T:\stress %~dp0stress /E /H /C /I
goto end

:cpperformance
xcopy T:\performance %~dp0performance /E /H /C /I
goto end

:cpall
xcopy T:\stress %~dp0sxtesttool\stress /E /H /C /I
xcopy T:\performance %~dp0sxtesttool\performance /E /H /C /I
goto end

:end
net use T: /delete

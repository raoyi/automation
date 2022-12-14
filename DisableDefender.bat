@echo off
TITLE DisableDefender - 20200928 - RaoYi
:info
echo.
echo this script will disable Windows Defender automatically
echo.
echo please run it as administrator
echo.
pause

:addreg
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f

:end
echo.
echo 1. reboot now
echo 2. reboot later
echo.
choice /T 5 /M "please input you choice in 5 secs." /C 12 /D 2
if errorlevel 2 exit
if errorlevel 1 shutdown -r -t 0

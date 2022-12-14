@echo off
title NetworkTest Auto Setting - author:RaoYi - 20200902

:scrprint
echo.
echo This script will modify Windows registry.
echo.
echo 1. set time zone to China Standard Time
echo 2. disable set time automatically
echo 3. set short date format to MM/dd/yyyy
echo 4. set short time format to HH:mm
echo 5. set long time format to HH:mm:ss
echo 6. set all PM value to never (Balanced)
echo 7. do not show powershell in winX menu
echo 8. disable Windows update
echo 9. show hidden file and file extension
echo 10. disable overwrite event logs
echo 11. disable UAC
echo 12. disable Windows firewall
echo 13. disable auto reboot and set complete dump
echo.
echo make sure run this as administrator.
echo.
pause
cls

rem 0. reg and powercfg backup
rem regedit /E %~dp0network-reg.reg
rem powercfg -export %~dp0powercfg.pow 381b4222-f694-41f0-9685-ff5bb260df2e

rem 1. set time zone
tzutil /s "China Standard Time"

rem 2. disable set time automatically
rem reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tzautoupdate" /v Start /t REG_DWORD /d 0x4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /t REG_SZ /d NoSync /f

rem 3. set short date format
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d MM/dd/yyyy /f

rem 4. set short time format
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortTime /t REG_SZ /d HH:mm /f

rem 5. set long time format
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d HH:mm:ss /f

rem 6. set all PM value to never
echo  6. set all PM value to never
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg /change /monitor-timeout-ac 0
powercfg /change /monitor-timeout-dc 0
powercfg /change /disk-timeout-ac 0
powercfg /change /disk-timeout-dc 0
powercfg /change /standby-timeout-ac 0
powercfg /change /standby-timeout-dc 0
powercfg /change /hibernate-timeout-ac 0
powercfg /change /hibernate-timeout-dc 0    

REM Setting power plan to blance
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e

REM The following script set Balanced

REM Set Dim the display to never
powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

REM Don't require a password when resume
powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000
powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000 

REM Power button: Do nothing
powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003

REM Sleep button: Do nothing
powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000

REM Close Lid: Do nothing
powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000

rem 7. turn off winX powershell
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DontUsePowerShellOnWinX /t REG_DWORD /d 0x1 /f

rem 8. disable windows update
echo 8. Disable Windows Automatic Update
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v NextDetectionTime /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallDate /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /V ScheduleInstallTime /f

rem 9. show hidden file and ext-name
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 0x1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 00000000 /f

rem 10. disable overwrite event logs
rem refer to 13

rem 11. disable UAC
echo 11. disable UAC
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f>nul
if %errorlevel%==1 goto error
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableXamlStartMenu" /t REG_DWORD /d "0" /f

rem 12. disable windows firewall
echo 12. disable windows firewall
REM firewall.cpl
netsh advfirewall set currentprofile state off
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off

rem 13. set Adjust System failure and recovery options
echo 13. disable auto reboot and set complete dump
REM sysdm.cpl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v LogEvent /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v Overwrite /t REG_DWORD /d 1 /f

rem - no dump = 0
rem - mini dump = 3
rem - kernel dump = 2
rem - complete dump = 1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 1 /f

goto end

:error
echo Could not disable UAC, please retry as administrator.
pause
goto error

:end
echo press any key to reboot...
pause>nul
shutdown -r -t 0

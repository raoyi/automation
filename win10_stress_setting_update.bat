
cls
REM Install futuremark
echo 0 Install Futuremark_SystemInfo
if exist %~dp0Futuremark_SystemInfo.exe call %~dp0Futuremark_SystemInfo.exe

cls
REM turn off UAC
echo 1 Turn off UAC
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f>nul
if %errorlevel%==1 set ERRORMSG=Could not disable UAC && goto ERROR
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableXamlStartMenu" /t REG_DWORD /d "0" /f

cls
REM set the power cfg
REM powercfg.cpl
echo 2 Adjust Power Configuration
powercfg /h on

REM set Balanced 
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg /change /monitor-timeout-ac 0
powercfg /change /monitor-timeout-dc 0
powercfg /change /disk-timeout-ac 0
powercfg /change /disk-timeout-dc 0
powercfg /change /standby-timeout-ac 0
powercfg /change /standby-timeout-dc 0
powercfg /change /hibernate-timeout-ac 0
powercfg /change /hibernate-timeout-dc 0    

REM set High performance
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change /monitor-timeout-ac 0
powercfg /change /monitor-timeout-dc 0
powercfg /change /disk-timeout-ac 0
powercfg /change /disk-timeout-dc 0
powercfg /change /standby-timeout-ac 0
powercfg /change /standby-timeout-dc 0
powercfg /change /hibernate-timeout-ac 0
powercfg /change /hibernate-timeout-dc 0

REM set Super Energy Saver
powercfg /setactive 8c5f2fda-e70f-4526-1a75-a9b23a8c635c
powercfg /change /monitor-timeout-ac 0
powercfg /change /monitor-timeout-dc 0
powercfg /change /disk-timeout-ac 0
powercfg /change /disk-timeout-dc 0
powercfg /change /standby-timeout-ac 0
powercfg /change /standby-timeout-dc 0
powercfg /change /hibernate-timeout-ac 0
powercfg /change /hibernate-timeout-dc 0

%WAIT%
           
REM set Power saver
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
powercfg /change /monitor-timeout-ac 0
powercfg /change /monitor-timeout-dc 0
powercfg /change /disk-timeout-ac 0
powercfg /change /disk-timeout-dc 0
powercfg /change /standby-timeout-ac 0
powercfg /change /standby-timeout-dc 0
powercfg /change /hibernate-timeout-ac 0
powercfg /change /hibernate-timeout-dc 0

REM set Energy Star
powercfg /setactive c0ea6ad3-6145-4447-a15e-5fb97be69b98
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


REM The following script set High performance

REM Set Dim the display to never
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

REM Don't require a password when resume
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000 

REM Power button: Do nothing
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003

REM Sleep button: Do nothing
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000

REM Close Lid: Do nothing
powercfg -setacvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -setdcvalueindex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000


REM The following script set Super Energy Saver

REM Set Dim the display to never
powercfg -setacvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
powercfg -setdcvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

REM Don't require a password when resume
powercfg -setacvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000
powercfg -setdcvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000 

REM Power button: Do nothing
powercfg -setacvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -setdcvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003

REM Sleep button: Do nothing
powercfg -setacvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -setdcvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000

REM Close Lid: Do nothing
powercfg -setacvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -setdcvalueindex 8c5f2fda-e70f-4526-1a75-a9b23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000


REM The following script set Power saver

REM Set Dim the display to never
powercfg -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
powercfg -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

REM Don't require a password when resume
powercfg -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000
powercfg -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000 

REM Power button: Do nothing
powercfg -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003

REM Sleep button: Do nothing
powercfg -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000

REM Close Lid: Do nothing
powercfg -setacvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -setdcvalueindex a1841308-3541-4fab-bc81-f71556f20b4a 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000


REM The following script set Energy Star

REM Set Dim the display to never
powercfg -setacvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0
powercfg -setdcvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 7516b95f-f776-4464-8c53-06167f40cc99 17aaa29b-8b43-4b94-aafe-35f64daaf1ee 0

REM Don't require a password when resume
powercfg -setacvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000
powercfg -setdcvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 fea3413e-7e05-4911-9a71-700331f1c294 0e796bdb-100d-47d6-a2d5-f7d2daa51f51 000 

REM Power button: Do nothing
powercfg -setacvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -setdcvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003

REM Sleep button: Do nothing
powercfg -setacvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -setdcvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000

REM Close Lid: Do nothing
powercfg -setacvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -setdcvalueindex c0ea6ad3-6145-4447-a15e-5fb97be69b98 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000

cls
REM Disable Screen Saver
REM Systemdm.cpl
echo 3 Set screen saver to none.

reg ADD "HKCU\Control Panel\Desktop" /v screensaveactive /t REG_SZ /d 0 /f 
reg DELETE "HKCU\Control Panel\Desktop" /v "SCRNSAVE.EXE" /f 

cls
REM Disable Windows Firewall
REM firewall.cpl
echo 4 Disable Windows Firewall
netsh advfirewall set currentprofile state off
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off

cls
REM Disable Windows Update
echo 5 Disable Windows Automatic Update
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v NextDetectionTime /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallDate /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /V ScheduleInstallTime /f

cls
rem - add Soft Blue Screen Key
echo   6 Add SoftBlueScreen Key (Fn+Ctrl+Scroll * 2)
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v CrashOnCtrlScroll /t REG_DWORD /d 1 /f

cls
REM set Adjust System failure and recovery options
REM sysdm.cpl
echo 7 Adjust System failure and recovery options
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v LogEvent /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v AutoReboot /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v Overwrite /t REG_DWORD /d 1 /f

rem - no dump = 0
rem - mini dump = 3
rem - kernel dump = 2
rem - complete dump = 1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 1 /f

cls
REM Disable Welcome Center auto-run
echo 8 Disable Welcome Center auto-run
reg DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "WindowsWelcomeCenter" /f 

cls
REM Disable AutoTray
echo 9 Disable AutoTray
reg add "HKCU\software\microsoft\windows\currentversion\explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f

cls
REM Enbable Win8 test mode
echo 10 Enbable Win8 test mode
reg add "HKLM\SYSTEM\CurrentControlSet\Control\7503491f-4a39-4f84-b231-8aca3e203b94" /t REG_SZ /d 1 /f

cls
REM Change System Volume
@echo Set WshShell = Wscript.CreateObject("Wscript.Shell")>ChangeVolume.vbs
@echo For i=1 to 150>>ChangeVolume.vbs
@echo WshShell.SendKeys "—¯">>ChangeVolume.vbs
@echo Next>>ChangeVolume.vbs
CScript //B ChangeVolume.vbs
DEL ChangeVolume.vbs

cls
rem - Shutdown stting 
echo   show Sleep Hibernate Lock in Power menu
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowSleepOption /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowHibernateOption /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowLockOption /t REG_DWORD /d 1 /f

goto end

:ERROR
color 1f
echo.
echo Error: %ERRORMSG%
echo The script could not complete the configuration steps.
echo.
echo Please make sure this script is run as administrator.
echo.
pause
goto :EOF

:end

::selectbatterymode
color f2
cls
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

cls
REM CHKDSK
REM echo y | chkdsk c: /f

"BurnIn install.exe"

color 3e
cls
echo ***********************************************************
echo    Press any key to restart the computer.
echo    Press any key to restart the computer.
echo    Press any key to restart the computer.
echo ***********************************************************
pause
shutdown -r -f -t 0

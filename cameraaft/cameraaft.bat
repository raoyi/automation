@echo off
if exist cam*.txt del cam*.txt

:prechk
if exist D:\MSTP\ThermalFAN\ThermalFANlog.txt goto dellog
if not exist D:\MSTP\ThermalFAN\ThermalFANlog.txt goto setlog

:dellog
del D:\MSTP\ThermalFAN\ThermalFANlog.txt
goto prechk

:setlog
echo PASS > CameraTestlog.txt

:chk
if not exist D:\MSTP\ThermalFAN\ThermalFANlog.txt goto chk

start CamQR.exe
copy CameraTestlog.txt cameraaftlog.txt

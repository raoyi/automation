<#
1. play video 1 loop, aoac, weakup
2. play video 3 loops, aoac, weakup
3. start quick scan, aoac, weakup
4. start download file, aoac, weakup
#>
$cycletime = 60
$video_time = 30
function aoac($cycletime)
{
    $cycletime=$cycletime*10+50
    # send M50 start
    .\SendSerial.exe 1 M50 1
    # win+x
    .\SendSerial.exe 1 M51 1
    # u
    .\SendSerial.exe 1 M53 1

    # set 15min delay
    .\SendSerial.exe 1 D193 $cycletime
    # active weakup delay
    .\SendSerial.exe 1 M57 1

    # s
    .\SendSerial.exe 1 M54 1
}

function time_chk()
{
    $strat_t = Get-Date
    aoac
    $end_t = $strat_t + ( New-TimeSpan -Seconds $cycletime )
    $in_test = $true
    while($in_test)
    {
        Start-Sleep -Seconds 20
        $now_t = Get-Date
        if($now_t -gt $end_t)
        {
            $in_test = $false
        }
    }
}

function connect
{
    $xmlname = 'WLAN-WindowsUpdate.xml'
    netsh wlan add profile filename=$xmlname
    [XML]$xmlstr=Get-Content $xmlname
    $wlanname=$xmlstr.WLANProfile.name
    If($wlanname -eq $null)
    {
        Write-Host 
        Write-Host ".xml file Error, cannot get wifi name!" -ForegroundColor Red
        Read-Host -Prompt "Please confirm the .xml file and retry."
        exit
    }
    Start-Sleep -Milliseconds 500
    netsh wlan connect name=$wlanname
}

# 如果没有 log 文件夹，则创建
if(!(Test-Path 'log'))
{
    New-Item -Path 'log' -ItemType Directory
}

# step 1 video 1 start==========================================
"video play once start - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt

Start-Process .\ffmpeg\ffplay.exe -argumentlist "-i","video.mp4"
#////////////////////////////////////
$strat_t = Get-Date
$end_t = $strat_t + ( New-TimeSpan -Seconds $video_time )
$in_test = $true
while($in_test)
{
    Start-Sleep -Seconds 20
    $now_t = Get-Date
    if($now_t -gt $end_t)
    {
        $in_test = $false
    }
}
TASKKILL /F /IM ffplay.exe /T
#////////////////////////////////////
"video play once end - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt

powercfg /sleepstudy /output ./log/report_pre.html
Start-Sleep -Seconds 10

"aoac in - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
time_chk
"aoac out - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt

powercfg /sleepstudy /output ./log/report_1.html

##################################################
# 检查SW/HW
# reportchk.exe report_before.html report_after.html
##################################################
# step 1 end====================================================

# step 2 video loop start=======================================
"video play loop start - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
Start-Process .\ffmpeg\ffplay.exe -argumentlist "-i","video.mp4","-loop","3"
Start-Sleep -Seconds 10
"aoac in - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
time_chk
"aoac out - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
##################################################
# 检查 ffplay.exe 进程
$pro_ffplay = (Get-Process).ProcessName | find `"ffplay`"
if($pro_ffplay -eq 'ffplay')
{
    # 1. 截图 1
    .\imgcut.exe ./log/screen1.jpg
    # 2. delay 15sec
    Start-Sleep -Seconds 15
    # 3. 截图 2
    .\imgcut.exe ./log/screen2.jpg
    # 4. 比对相似度，如果 相似度 < 0.7，结束 ffplay.exe 进程，PASS
    .\imgcomp.exe ./log/screen1.jpg ./log/screen2.jpg ./log/imgcomp.log
    $res_comp = (Get-Content ./log/imgcomp.log)
    if($res_comp -eq 'different')
    {
        Write-Host "Video Loop Test PASS!"
        "Video Loop Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
        TASKKILL /F /IM ffplay.exe /T
    }
    else
    {
        Start-Sleep -Seconds 60
        imgcut.exe ./log/screen2.jpg
        imgcomp.exe ./log/screen1.jpg ./log/screen2.jpg ./log/imgcomp.log
        $res_comp = (Get-Content ./log/imgcomp.log)
        if($res_comp -eq 'different')
        {
            Write-Host "Video Loop Test PASS!"
            "Video Loop Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
            TASKKILL /F /IM ffplay.exe /T
        }
        else
        {
            Write-Host "Video Loop Test FAIL, Image Similar!"
            "Video Loop Test FAIL, Image Similar! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
            Read-Host
        }
    }
}
else
{
    Write-Host "Video Loop Test FAIL, No Process Named ffplay!"
    "Video Loop Test FAIL, No Process Named ffplay! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    Read-Host
}
powercfg /sleepstudy /output ./log/report_2.html
# step 2 end====================================================

# step 3 quick scan start=======================================
"quick scan start - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
# 进程名 MpCmdRun.exe
Start-Process "powershell.exe" -ArgumentList "-file","mpcmdrun.ps1"
Start-Sleep -Seconds 2
"aoac in - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
time_chk
"aoac out - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt

# 检查 MpCmdRun.exe 进程
$pro_mpcmdrun = (Get-Process).ProcessName | find `"MpCmdRun`"
# 如果存在，结束 MpCmdRun.exe 进程，PASS
# 如果不存在，$s[-1] = 'Scan finished.'，PASS
# 否则 FAIL
if($pro_mpcmdrun -eq 'MpCmdRun')
{
    Write-Host "MpCmdRun Test PASS!"
    "MpCmdRun Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    TASKKILL /F /IM MpCmdRun.exe /T
}
else
{
    if((Get-Content ./log/mpcmdrun.log)[-1] -eq 'Scan finished.')
    {
        Write-Host "MpCmdRun Test PASS!"
        "MpCmdRun Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    }
    else
    {
        Write-Host "MpCmdRun Test FAIL!"
        "MpCmdRun Test FAIL! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    }
}
powercfg /sleepstudy /output ./log/report_3.html
# step 3 end====================================================

# step 4 download file start====================================
# 1. 联网
connect

Start-Sleep -Seconds 5
"File Download start - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
# File Length:3826831360
Start-Process .\wget.exe -argumentlist "-O","./log/download_file.iso","https://repo.huaweicloud.com/ubuntu-releases/22.04.1/ubuntu-22.04.1-desktop-amd64.iso"
Start-Sleep -Seconds 5
"aoac in - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
time_chk
"aoac out - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
# chk file size
$file_size = (ls ./log/download_file.iso).Length
if($file_size -eq 3826831360)
{
    Write-Host "File Download Test PASS!"
    "File Download Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
}
else
{
    Start-Sleep -Seconds 2
    $file_size2 = (ls ./log/download_file.iso).Length
    if($file_size2 -gt $file_size)
    {
        Write-Host "File Download Test PASS!"
        "File Download Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    }
    else
    {
        Write-Host "File Download ERROR!"
        "File Download ERROR! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    }
}
powercfg /sleepstudy /output ./log/report_4.html
# step 4 end====================================================

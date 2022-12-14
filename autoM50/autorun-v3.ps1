<#
1. play video 1 loop, aoac 900secs, weakup
2. play video 3 loops, aoac 900secs, weakup
3. start quick scan, aoac 900secs, weakup
4. start download file, aoac 900secs, weakup
#>
$test_t = 30
"Test time:"+$test_t+" - "+$(Get-Date)|Out-File ./log/aoac_log.txt
function aoac($cycletime=$test_t)
{
    $cycletime=$cycletime*10+100
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
    # get start time
    #$strat_t = Get-Date

    aoac
    <#
    $in_test = $true
    while($in_test)
    {
        Start-Sleep -Seconds 20
        $now_t = Get-Date
        $chk_t = (New-TimeSpan $sta_t $now_t).Minutes
        if($chk_t -ge ($args[0]/60))
        {
            $in_test = $false
        }
    }
    #>
    Start-Sleep -Seconds $test_t
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
<#
# get start time
$strat_t = Get-Date
$in_test = $true
while($in_test)
{
    Start-Sleep -Seconds 30
    $now_t = Get-Date
    $chk_t = (New-TimeSpan $sta_t $now_t).Minutes
    if($chk_t -ge 1)
    {
        $in_test = $false
    }
}
#>
Start-Sleep -Seconds $test_t
TASKKILL /F /IM ffplay.exe /T
#////////////////////////////////////
"video play once end - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt

powercfg /sleepstudy /output ./log/report_pre.html
Start-Sleep -Seconds 5

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
Start-Sleep -Seconds 5
"aoac in - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
time_chk
"aoac out - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
##################################################
# 检查 ffplay.exe 进程
$pro_ffplay = (Get-Process).ProcessName | find `"ffplay`"
if($pro_ffplay -eq 'ffplay')
{
    # 1. 截图 1
    .\imgcut.exe screen1.jpg
    # 2. delay 15sec
    Start-Sleep -Seconds 15
    # 3. 截图 2
    .\imgcut.exe screen2.jpg
    # 4. 比对相似度，如果 相似度 < 0.7，结束 ffplay.exe 进程，PASS
    .\imgcomp.exe screen1.jpg screen2.jpg
    $res_comp = (Get-Content imgcomp.log)
    if($res_comp -eq 'different')
    {
        Write-Host "Video Loop Test PASS!"
        "Video Loop Test PASS! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
        TASKKILL /F /IM ffplay.exe /T
    }
    else
    {
        Start-Sleep -Seconds 30
        imgcut.exe screen2.jpg
        imgcomp.exe screen1.jpg screen2.jpg
        $res_comp = (Get-Content imgcomp.log)
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
    if(!(Test-Path ./log/mpcmdrun.log))
    {
        Write-Host "MpCmdRun Test FAIL!"
        "MpCmdRun Test FAIL! - "+$(Get-Date)|Out-File -Append ./log/aoac_log.txt
    }
    else
    {
        if((Get-Content .\log\mpcmdrun.log) -eq 'Scan finished.')
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
}
powercfg /sleepstudy /output ./log/report_3.html
# step 3 end====================================================

# step 4 download file start====================================
# 1. 联网
# connect

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

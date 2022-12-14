$Host.UI.RawUI.WindowTitle="AutoConnectWifi - SAMXVM"

function connect
{
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

$n=(Get-ChildItem -File "*.xml"|Select-Object Name).Name

If($n.Count -eq 0)
{
    Write-Host 
    Write-Host "No .xml file in the path." -ForegroundColor Red
    Read-Host -Prompt "Press Enter key to EXIT..."
    exit
}
If($n.Count -gt 1)
{
    Write-Host 
    Write-Host "There are following .xml files in the path."
    Write-Host "==========================================="
    for ($i=1; $i -le $n.Count; $i++)
    {
        $iname=$n[$i-1]
        Write-Host $i". "$iname
    }
    Write-Host "==========================================="
    $wifinum = Read-Host -Prompt "Please Enter ID"
    for ($j=1; $j -le $n.Count; $j++)
    {
        If($j -eq $wifinum)
        {
            $xmlname = $n[$j-1]
        }
    }
    If($xmlname -eq $null)
    {
        exit
    }
    connect
}
If($n.Count -eq 1)
{
    $xmlname=$n
    connect
}


$Host.UI.RawUI.WindowTitle="ImportPreloadModuleTool - SAMXVM"

$locdirs=[Environment]::GetLogicalDrives()

Write-Host "First you want to:"
Write-Host "1. Map dirve L:\"
Write-Host "2. Start copying directly"
$todo=Read-Host "Enter you choice [1,2]"

if ($todo -eq "1")
{
for($i=0;$i -le $locdirs.Count;$i++)
{
    if($locdirs[$i] -eq "L:\")
    {
        net use L: /del
    }
}
net use L: \\100.105.16.3\images "sx=123" /user:"administrator"
}
$from_dir="L:\"
$aodpath="N:\MTSN\aod.dat"
$to_dir="N:\module\"

if(!(Test-Path $aodpath))
{
    write-host $aodpath"is not exist!"
    Read-Host
    exit
}
if(!(Test-Path $to_dir))
{
    write-host $to_dir"is not exist!"
    Read-Host
    exit
}
if(!(Test-Path $from_dir))
{
    write-host $from_dir"is not exist!"
    Read-Host
    exit
}

foreach ($line in [System.IO.File]::ReadLines($filename)) {
    if($line.split(".")[-1] -eq "CRI")
    {
        $modname=$line.split(".")[-2].Split("=")[-1]#
        $modcri=$modname+".CRI"
        $modpath=Join-Path $from_dir $modname
        $modpath=$modpath+".*"
        if(!(Test-Path (Join-Path $to_dir $modcri)))
        {
            Write-Host "COPY AOD"$modname
            Copy-Item -Path $modpath -Destination $to_dir
        }
        # check md5
        $md5files=(Get-ChildItem -File "a.*"|Select-Object Name).Name
        for($i=0;$i -lt $md5files.Count;$i++)
        {
            $md5ingfile=$md5files[$i]
            $sourcepath=Join-Path $from_dir $md5ingfile
            $targetpath=Join-Path $to_dir $md5ingfile
            $sourcemd5=(Get-FileHash $sourcepath -Algorithm MD5).Hash
            $targetmd5=(Get-FileHash $targetpath -Algorithm MD5).Hash
            while($sourcemd5 -ne $targetmd5)
            {
                Write-Host $modname"MD5 Error, retry..."
                Copy-Item -Path $modpath -Destination $to_dir
                $sourcemd5=(Get-FileHash $sourcepath -Algorithm MD5).Hash
                $targetmd5=(Get-FileHash $targetpath -Algorithm MD5).Hash
            }
            Write-Host $modname"copy pass!"
        }
    }
}
Write-Host "AOD COPY FINISHED!"
Read-Host
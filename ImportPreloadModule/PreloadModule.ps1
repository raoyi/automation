# line 21 serverip/password/username need set

$Host.UI.RawUI.WindowTitle="ImportPreloadModuleTool - SAMXVM"

$locdirs=[Environment]::GetLogicalDrives()

Write-Host "You want to:"
Write-Host "1. Map dirve L:\ & Copy modules"
Write-Host "2. Start copy modules directly"
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
net use L: \\ServerIP\images "password" /user:"username"
}

$from_dir="L:\"
$aodpath="N:\MTSN\aod.dat"
$to_dir="N:\modules\"

if(!(Test-Path $aodpath))
{
    write-host $aodpath"is not exist!" -ForegroundColor Red
    Read-Host
    exit
}
if(!(Test-Path $to_dir))
{
    write-host $to_dir"is not exist!" -ForegroundColor Red
    Read-Host
    exit
}
if(!(Test-Path $from_dir))
{
    write-host $from_dir"is not exist!" -ForegroundColor Red
    Read-Host
    exit
}

foreach ($line in [System.IO.File]::ReadLines($aodpath)) {
    if($line.split(".")[-1] -eq "CRI")
    {
        $modname=$line.split(".")[-2].Split("=")[-1]#
        $modcri=$modname+".CRI"
        $modpath=Join-Path $from_dir $modname
        $modpath=$modpath+".*"
        $modtopath=Join-Path $to_dir $modname
        $modtopath=$modtopath+".*"

        if(!(Test-Path (Join-Path $to_dir $modcri)))
        {
            if((Test-Path (Join-Path $from_dir $modcri)))
            {
                Write-Host "COPY AOD"$modname
                Copy-Item -Path $modpath -Destination $to_dir
            }
            else
            {
                Write-Host (Join-Path $from_dir $modcri)"not exist!" -ForegroundColor Red
                Read-Host
            }
            #=============================================================================
            # check md5
            $md5files=(Get-ChildItem -File $modtopath|Select-Object Name).Name
            for($i=0;$i -lt $md5files.Count;$i++)
            {
                if($md5files.Count -eq 1)
                {
                    $md5ingfile=$md5files
                }
                else
                {
                    $md5ingfile=$md5files[$i]
                }
                ############
                # Write-Host "MD5 files "$md5files
                # Write-Host $md5files.Count
                # Write-Host "MD5 file 1 "$md5ingfile
                ############
                $sourcepath=Join-Path $from_dir $md5ingfile
                $targetpath=Join-Path $to_dir $md5ingfile
                #######################################
                # Write-Host $sourcepath $targetpath
                # pause
                #######################################
                $sourcemd5=(Get-FileHash $sourcepath -Algorithm MD5).Hash
                $targetmd5=(Get-FileHash $targetpath -Algorithm MD5).Hash
                #########################
                # pause
                #########################
                while($sourcemd5 -ne $targetmd5)
                {
                    Write-Host $modname"MD5 Error, retry..." -ForegroundColor Red
                    Copy-Item -Path $modpath -Destination $to_dir
                    $sourcemd5=(Get-FileHash $sourcepath -Algorithm MD5).Hash
                    $targetmd5=(Get-FileHash $targetpath -Algorithm MD5).Hash
                }
                Write-Host $md5ingfile" MD5 PASS!" -ForegroundColor Green
            }
            #=============================================================================
        }
        else
        {
            Write-Host $modcri "EXIST!"
        }
    }
}
Write-Host "ALL AODs COPY FINISHED!" -ForegroundColor Green
Read-Host
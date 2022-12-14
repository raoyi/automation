$p = 'C:\ProgramData\Microsoft\Windows Defender\Platform\'
$n = (Get-ChildItem $p).Name[-1]

$swname = Join-Path (Join-Path $p $n) -ChildPath 'MpCmdRun.exe'

# "this is a demo" Out-File ./log/mpcmdrun.log
# "Scan finished." Out-File -Append ./log/mpcmdrun.log

$s = & $swname -scan -scantype 1
$s|Out-File ./log/mpcmdrun.log

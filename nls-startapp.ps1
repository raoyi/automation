#$data = Get-StartApps|ConvertTo-Json|ConvertFrom-Json
$Host.UI.RawUI.WindowTitle="NLS-StartApp - v1.1"
Write-Host
Write-Host "==========================================="
Write-Host "  Start Applications Automatically"
Write-Host "  used for LCFC TNB NLS test"
Write-Host "  created at 2022-06-06   v1.1"
Write-Host "  feedback: yi.rao@samxvm.com"
Write-Host "==========================================="
$data = Get-StartApps
for ($n=0; $n -lt $data.count; $n++) {
    Write-Host 
    Write-Host "Application ["($n+1)"/"$data.count"]:"
    Write-Host "    App name:" $data.name[$n]
    $id = $data.appid[$n]
    Write-Host "    App ID:" $id
    pause
    start "shell:appsfolder\$id"
}

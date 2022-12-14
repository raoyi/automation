param( $param1, $param2 )

#region 关键代码：强制以管理员权限运行
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent() 
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
{ 
  $boundPara = ($MyInvocation.BoundParameters.Keys | foreach{'-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
  $currentFile = (Resolve-Path  $MyInvocation.InvocationName).Path 
 
 $fullPara = $boundPara + ' ' + $args -join ' '
 Start-Process "$psHome\powershell.exe" -ArgumentList "$currentFile $fullPara" -verb runas 
 return
} 
#endregion

# 需要执行的脚本示例
"param1=$param1, param2=$param2"
Write-Host  'runing script success'
Read-Host

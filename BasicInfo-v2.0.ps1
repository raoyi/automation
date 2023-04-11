$Host.UI.RawUI.WindowTitle="Basic Info - SAMXVM@230411"

# List information
function Pcinfo 
{
  #param([string]$savepath)  
#cls
$system = Get-WmiObject -Class Win32_ComputerSystem
#获取计算机域名、型号
$domainname = $system.Domain
$model = $system.Model
$user=$system.UserName
#获取计算机IP地址,取IP不为空的网卡IP地址
#$ips = gwmi Win32_NetworkAdapterConfiguration |?{ $_.IPAddress -ne $null}
#$ipdata=$null
#foreach ($ip in $ips )
#{
#查找对应网速
#$ok=Get-WmiObject -Class Win32_NetworkAdapter -Filter "Description='$($ip.Description)'"|Select-Object Description,speed,MACAddress
# $ipdata+="Name:$($ip.Description) IP:$($ip.IPAddress[0]) Speed:$($ok.speed/1000/1000)M MAC:$($ok.MACAddress)`n`r"
#}
#$ipdata=$ipdata.Substring(0,$ipdata.Length-2)


#获取操作系统版本
$os = Get-WmiObject -Class Win32_OperatingSystem

#获取操作系统版本
$os_caption =  $os.Caption
If ($os_caption.Contains("Server 2008 R2 Enterprise"))
{$os_caption_s = "Win2008"}
ElseIf ($os_caption.Contains("Server 2003 Enterprise"))
{$os_caption_s = "Win2003"}
Else {$os_caption_s = $os.Caption}
$osversion = $os_caption_s + " " + $os.OSArchitecture.Substring(0,2) + "bit"


#获取CPU名称、单颗CPU核心数量*CPU个数
$cpus = Get-WmiObject -Class win32_processor
$cpunamecore=$null
Foreach ($cpu in $cpus)
  {
 $cpunamecore += "$($cpu.name) $($cpu.NumberOfCores) Core $($cpu.NumberOfLogicalProcessors) Thread`n`r"
  }
 $cpunamecore = $cpunamecore.Substring(0, $cpunamecore.Length-2)
#获取内存大小
$memorys = Get-WmiObject -Class Win32_PhysicalMemory
$memorylist = $null
$memorysize_sum = $null
$memorysize_sum_n=0
Foreach ($memory in $memorys)
  {
  #$memory|Select-Object * |fc
   $memorylist +="Brand:$($memory.Manufacturer.Trim()),"+"Frequency:$($memory.Speed)MZ,Size:" +($memory.capacity/1024/1024/1024).tostring("F1")+"GB`n`r"
   
  }
$memorylist=$memorylist.Substring(0,$memorylist.Length-2)

#获取磁盘信息
$disks = Get-WmiObject -Class Win32_Diskdrive
$disklist = $null
#$disksize_sum = $null
Foreach ($disk in $disks)
  {
 
   $disklist += ($disk.deviceid.replace("\\.\PHYSICALDRIVE","Disk") +":Model,$($disk.model) Firmware,"+ (((Get-WmiObject -Class Win32_PNPEntity).HardwareID | Select-String (($disk.model -split " ")[1])) -split (($disk.model -split " ")[1]))[1]+" Size,"  + [int]($disk.size/1024/1024/1024)+"GB`n`r")
   #$disksize_sum+=$disk.size
  }
 $disklist= $disklist.Substring(0, $disklist.Length-2)
#获取计算机序列号、制造商
$bios = Get-WmiObject -Class Win32_BIOS
$sn = $bios.SerialNumber
If ($sn.Substring(0,6) -eq "VMware")
   {$sn = "VMware"}
If ($bios.Manufacturer.contains("Dell"))
  {$manufacturer = "Dell"} 
Elseif ($bios.Manufacturer.contains("HP")) 
  {$manufacturer = "HP"} 
Elseif ($bios.Manufacturer.contains("Microsoft")) 
  {
   $manufacturer = "Microsoft"
   $sn = ""
   }
Else {$manufacturer = $bios.Manufacturer}
$type = $manufacturer + " " + $model
if ($type.contains("Microsoft Virtual Machine"))
    {$type = "Hyper-V"}
#获取声卡信息
$sound=Get-WmiObject -Class Win32_SoundDevice
$soundnew=$null
foreach ($i in $sound)
{
   $soundnew+="$($i.name)`n`r"  
}
$soundnew=$soundnew.Substring(0,$soundnew.Length-2)
$soundnew=($soundnew -split '\n\r'|Sort-Object -Unique) -join "`n`r"

#获取显卡信息
$view=Get-WmiObject -Class Win32_VideoController
$viewnew=$null
foreach ($item in $view)
{
#判断是否小于1G,显示M
$xc=$item.AdapterRAM/1024/1024/1024
switch ($xc)
{
   
    {$_ -lt 1} {$xcdata="$([math]::Ceiling($item.AdapterRAM/1024/1024))M"}
   
    Default {$xcdata="$([math]::Ceiling($item.AdapterRAM/1024/1024/1024))G"}
}
  $viewnew+= "Name:$($item.Caption),VideoMemorySize:$($xcdata)`n`r"
}
$viewnew=$viewnew.Substring(0,$viewnew.Length-2)
#获取主板信息
$basebord=Get-WmiObject -Class Win32_BaseBoard -Property * 
$basebordnew="$($basebord.Manufacturer) $($basebord.Product)"
#获取打印机信息
$aa=Get-WmiObject -Class win32_printer -Filter "PortName like '%USB%' and Local=True"|select @{N="printer";e={
if($_.WorkOffline -eq $true){return "$($_.DriverName)(OffLine)"} else{ return "$($_.DriverName)(OnLine)"}
}}
$pris=$aa.printer -join ','

#获取显示器信息
$Screen=Get-WmiObject -Class Win32_DesktopMonitor|Select-Object @{l="Monitor";e={$($_.PNPDeviceID -split '\\')[1]}}
$Scr=$Screen.Monitor -join ','
$Scr=(gwmi WmiMonitorID -Namespace root\wmi).InstanceName -join ','
##################
$pix=(Get-WmiObject -Class Win32_PNPEntity).Name|Select-String 'display'
$camid=((Get-WmiObject -ClassName Win32_PnPEntity|where{$_.name -eq 'Integrated Camera'}).HardwareID)[0]
$camvendor=(Get-WmiObject -ClassName Win32_PnPEntity|where{$_.name -eq 'Integrated Camera'}).Manufacturer
$caminfo=$camvendor+' | '+$camid
##################

$Infors= [ordered]@{ComputerName=$env:ComputerName;CurrentUser=$user;OSversion= $osversion;RAM=$memorylist; 
CPU=$cpunamecore;WorkgroupOrDomain=$domainname;Disk=$disklist;BIOSversion=$type;MBmanufacturer=$basebordnew;SerialNumber=$sn;SoundCard=$soundnew;VideoCard=$viewnew;Screen=$Scr;Monitor=$pix;CAMERA_INFO=$caminfo}
$news=[pscustomobject]$Infors
$news
#更新CSV
#if(Test-Path $savepath){
#$list=Import-Csv $savepath  -Encoding Default
#if($list.计算机名.IndexOf($news.计算机名) -eq -1){
#$news|Export-Csv -NoTypeInformation $savepath -Encoding Default -Append -Force
#}
#}else{
#$news|Export-Csv -NoTypeInformation $savepath -Encoding Default -Force}

Write-Host "All Network Adapter List:"
(Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.MACAddress -ne $null}).Name

Write-Host "MAX SUPPORTED RAM:$((Get-WmiObject -Class Win32_PhysicalMemoryarray).MaxCapacity/1024/1024)G" -ForegroundColor Red
}
#pcinfo -savepath .\info.csv
pcinfo
Read-Host

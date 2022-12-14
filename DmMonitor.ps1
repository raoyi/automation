# check Device Manager

function GetDevStatus {
    $Device_other = @()
    $Device_yellowbang = @()
    $CameraNum=0
    $All_List = Get-WmiObject -Class Win32_PNPEntity
    foreach ($i in $All_List) {
        if ($Null -ne $i.Name  -and $Null -eq $i.PNPClass) {
            $Device_other += ($i.Name)
        }
        if ($i.Status -eq "Error") {
            $Device_yellowbang += ($i.Name)
        }
    }
    return $Device_other, $Device_yellowbang
}

function CatchChange {
    $device=Get-WmiObject -Class Win32_PNPEntity
    $device_num=$device.Length
    while ($device_num -eq((Get-WmiObject -Class Win32_PNPEntity).Length)){

    }
    if ($device_num -gt((Get-WmiObject -Class Win32_PNPEntity).Length)){
        Write-Host("Remove Device")
    }
    else{
        Write-Host("Add Device")
    }
    $device_Change=Get-WmiObject -Class Win32_PNPEntity
    $device_Compare=Compare-Object $device $device_Change
    Write-Host($device_Compare.InputObject.Name) 
}

# CatchChange
$a = GetDevStatus
 
if ($Null -eq $a) {
    Write-Host("No Error")
}
else {
    Write-Host("************ Other Devices ************")
    $a[0]
    Write-Host("")
    Write-Host("************ YellowBang Devices ************")
    $a[1]
    Write-Host("")
}
Write-Host("************ Listening Device Change ************")
while ($True){
    CatchChange
}

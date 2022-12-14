$DesignedCapacity = (Get-WmiObject -Class "BatteryStaticData" -Namespace "ROOT\WMI").DesignedCapacity 
$FullChargedCapacity = (Get-WmiObject -Class "BatteryFullChargedCapacity" -Namespace "ROOT\WMI").FullChargedCapacity 
if($DesignedCapacity.Length -eq 1){
    Write-Host "Designed Capacity" $DesignedCapacity 
    Write-Host "Full Charged Capacity" $FullChargedCapacity
    $percentage = $FullChargedCapacity/$DesignedCapacity * 100
    if ($FullChargedCapacity -gt ($DesignedCapacity * 0.95 -0.3))
    {
        Write-Host "The battery meet the requirement of Battery life test."
    }
    else
    {
        Write-Host "The battery cannot meet the requirement of Battery life test."
    }
}elseif($DesignedCapacity.Length -eq 2){
    Write-Host "Battery 1 Designed Capacity" $DesignedCapacity[0]
    Write-Host "Battery 1 Full Charged Capacity" $FullChargedCapacity[0]
    Write-Host "Battery 2 Designed Capacity" $DesignedCapacity[1]
    Write-Host "Battery 2 Full Charged Capacity" $FullChargedCapacity[1]
    if (($FullChargedCapacity[0] + $FullChargedCapacity[1]) -gt (($DesignedCapacity[0] + $DesignedCapacity[1]) * 0.95 -0.3))
    {
        Write-Host "The battery meet the requirement of Battery life test."
    }
    else
    {
        Write-Host "The battery cannot meet the requirement of Battery life test."
    }
}else{
    Write-Host "Cannot get battery information."
}
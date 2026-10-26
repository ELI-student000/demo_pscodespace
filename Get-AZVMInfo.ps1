[CmdletBinding()]
Param(
    [String]$Location="Japan East"
)

Clear-AzContext -Force
$AzProfile=Connect-AzAccount

$SubscriptionName = $AzProfile.Context.Subscription.Name
$TenantID= $AzProfile.Context.Tenant.Id
$Tenant = Get-AzTenant -TenantId $TenantID
$TenantName=$Tenant.Name

Write-Host "■テナント：`t`t $TenantName"
Write-Host "■サブスクリプション：`t $SubscriptionName"

$ResourceGroups=Get-AzResourceGroup -Location $Location | Sort-Object ResourceGroupName

IF($ResourceGroups -eq $null)
{
    Write-Host "指定されたロケーションには、リソースグループは存在しません。"
    exit
}
Write-Host "■$Location のリソースグループ一覧:"
[int]$Counter=1

foreach($RG in $ResourceGroups){
    $RGName = $RG.ResourceGroupName
    $AZVMs=Get-AZVM -ResourceGroupName $RGName -Status
    
    Write-Host　"`t $Counter) $RGName リソースグループ"
    If ($AZVMs -eq $null){
           Write-Host "`t`t・仮想マシンは存在しません。"
    }Else{
        foreach($VM in $AZVMs){
            $VMName=$VM.Name
            $PowerState=$VM.PowerState
            $VMSize=$VM.HardwareProfile.VmSize
            Write-Host "`t`t・仮想マシン名:`t　$VMName"
            Write-Host　"`t`t`t(サイズ: $VMSize  状態: $PowerState )"
        }
    }
    $Counter++  
}

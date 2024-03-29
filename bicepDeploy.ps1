# sign in with a different tenant
# Connect-AzAccount --tenant "<<tenant-Id-you-get-from-Entra :D >>"

## To check if az bicep present
# az bicep version

## If az bicep cli not present
# az bicep install

$resourceGroupName = "<<rg-name :D >>"
$date = Get-Date -Format "MM-dd-yyyy"
$rand = Get-Random -Maximum 1000

$deploymentName = `
    "WofoDeployment-" + `
    "$date" + "-" + `
    "$rand"

### Deploy Vm
$bicepTemplate = $PSScriptRoot + "/Vm/vm.bicep"
$bicepParamsTemplate = $PSScriptRoot + "Vm/vm.bicepparam"

# -Mode Complete - Solo se necessario, sennò si va di Incremental
New-AzResourceGroupDeployment `
    -Mode Complete `
    -Name $deploymentName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $bicepTemplate `
    -TemplateParameterFile $bicepParamsTemplate -c
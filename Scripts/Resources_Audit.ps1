# make csv file with Name, type, resource group and location of each resource in the current subscription
Get-AzResource | Select-Object -Property ResourceName,ResourceType,ResourceGroupName,Location | Export-Csv -Path .\ResourcesAudit.csv -NoTypeInformation

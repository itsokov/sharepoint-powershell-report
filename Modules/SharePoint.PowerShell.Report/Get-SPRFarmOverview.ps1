function Get-SPRFarmOverview
{
  param
  (
    [Parameter(Mandatory)]
    [object]$SPRFarm,
    [Parameter(Mandatory)]
    [object[]]$SPRDatabases
  )
	
  $date = Get-Date
  $configurationDatabase = $SPRDatabases | Where-Object -FilterScript {
    $_.Type -eq 'Configuration Database'
  }
  $patchLevel = Get-SPRSharePointBuild -BuildVersion $SPRFarm.BuildVersion
  $license = Get-SPRSharePointLicense -Products $SPRFarm.Products
	
  $properties = [ordered]@{
    'FarmName'            = $SPRFarm.Name
    'BuildVersion'        = $SPRFarm.BuildVersion.ToString()
    'PatchLevel'          = $patchLevel
    'SharePointLicense'   = $license
    'ConfigurationDatabase' = $configurationDatabase.Name
    'FarmServerCount'     = $SPRFarm.Servers.Count
    'ReportCreatedOn'     = $date.ToString()
  }
	
  $output = New-Object -TypeName PSObject -Property $properties
	
  Write-Output -InputObject $output
}
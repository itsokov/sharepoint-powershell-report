function Get-SPRFarmFeatures
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPFarmFeatures,
    [Parameter(Mandatory = $true)]
    [object[]]$SPWebServicesAdministration
  )
	
$FarmFeatures=$SPFarmFeatures | ? {$_.Scope.value -eq "Farm"}
$ActiveFarmFeatures=$SPWebServicesAdministration

  foreach ($FarmFeature in $FarmFeatures)
  {
    $isactive=$false
    foreach ($ActiveFarmFeature in $ActiveFarmFeatures) {
   
    if ($FarmFeature.id -eq $ActiveFarmFeature.definitionid) {$isactive=$true} 
    
    }
    $properties = [ordered]@{
      'Title'  = $FarmFeature.DisplayNameEN
      'Id'     = $FarmFeature.id
      'Solution' = $FarmFeature.SolutionID
      'Version' = $FarmFeature.Version
      'Active' = $isactive
      'Hidden' = $FarmFeature.Hidden
      'Custom' = $XXX
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output

    
  }
}
function Get-SPRWebApplicationFeatures
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPRFeature,
    [Parameter(Mandatory = $true)]
    [object[]]$SPRwebApplication
  )
	
  $features = $SPRFeature | Where-Object { $_.Scope.Value -eq 'WebApplication' }
  
  foreach ($webApplication in $SPRwebApplication)
  {
    foreach ($feature in $features)
    {
      $isActive = ($webApplication.Features | Where-Object {$_.DefinitionId -eq $feature.Id}) -ne $null
      
      $properties = @{
        'WebApplication'      = $webApplication.DisplayName
        'FeatureName'      = $feature.Title
        'CompatibilityLevel' = $feature.CompatibilityLevel
        'IsActive'         = $isActive
      }
    
      $output = New-Object -TypeName PSObject -Property $properties
      
      Write-Output -InputObject $output
    }
  }
}
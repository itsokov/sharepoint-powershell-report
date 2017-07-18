function Get-SPRSearchManagedProperties
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPREnterpriseSearchServiceApplications
  )
	
$output=@()
  foreach ($SPREnterpriseSearchServiceApplication in $SPREnterpriseSearchServiceApplications)
  {
    foreach ($managedProperty in $SPREnterpriseSearchServiceApplication.ManagedProperties)
    {
        foreach ($crawledProperty in $SPREnterpriseSearchServiceApplication.CrawledProperties)
        {
        
            if ($managedProperty.PID -eq $crawledProperty.ManagedPid)
            {
               
               $properties = @{ 
               "ServiceApplication" = $SPREnterpriseSearchServiceApplication.Name
               "ServiceApplicationID" = $SPREnterpriseSearchServiceApplication.ID
               "ManagedPropertyName" = $managedProperty.Name
               "CrawledPropertyName" = $crawledProperty.CrawledPropertyName
               'Type'             = $managedProperty.ManagedType
               'MayBeDeleted'     = !($managedProperty.DeleteDisallowed)
               'UseInScopes'     = $managedProperty.EnabledForScoping
               'Optimized'        = $managedProperty.IsInFixedColumnOptimizedResults

               }
               
               $object=New-Object -TypeName "PSObject" -Property $properties
               $output+=$object
        
            }
        
        
        }
    
    }
    
		
    Write-Output -InputObject $output
  }
}
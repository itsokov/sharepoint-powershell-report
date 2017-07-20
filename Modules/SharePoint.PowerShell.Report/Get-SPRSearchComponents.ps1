function Get-SPRSearchComponents
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPREnterpriseSearchServiceApplications
  )
  $output =@()
  foreach ($SPREnterpriseSearchServiceApplication in $SPREnterpriseSearchServiceApplications)
  {
  
  foreach ($SearchComponent in $SPREnterpriseSearchServiceApplication.components)
   {
    $properties = [ordered]@{
      'Name'             = $SearchComponent.Name
      'ActiveTopology'         = $SearchComponent.TopologyId
      'ServiceApplication' = $SPREnterpriseSearchServiceApplication.Name
      'ServiceApplicationID' = $SPREnterpriseSearchServiceApplication.ID
      'Server'           = $SearchComponent.ServerName

    }
    $object = New-Object -TypeName PSObject -Property $properties
    $output+=$object
	}	
    Write-Output -InputObject $output
  }
}
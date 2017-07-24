function Get-SPRServiceApplicationsList
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPRServiceApplications
  )
	
  foreach ($serviceApplication in $SPRServiceApplications)
  {
    $properties = [ordered]@{
      'Name'          = $serviceApplication.Name
      'TypeName'          = $serviceApplication.TypeName
      'Status'        = $serviceApplication.status.ToString()
      'ApplicationPool' = $serviceApplication.ApplicationPool
      'Databases'     = $serviceApplication.database
      'ApplicationPoolAccount'=$serviceApplication.ApplicationPoolAccount
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
}
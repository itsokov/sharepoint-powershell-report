#requires -Version 3.0
function Get-SPRServicesOnServer
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPRServer
  )
  $output = @()
  
  $sharepointServers = $SPRServer | Where-Object -FilterScript {
    $_.Role -ne 'Invalid'
  }
  
  foreach ($server in $sharepointServers)
  {
    foreach ($serviceInstance in $SPRServer.ServiceInstances)
    {
      $properties = [ordered]@{
        'Server'      = $server.Address
        'ServiceName' = $serviceInstance.TypeName
        'ServiceStatus' = $serviceInstance.Status
      }
      $entry = New-Object -TypeName PSObject -Property $properties
      $output += $entry
    }
  }
  Write-Output -InputObject $output
}

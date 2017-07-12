function Get-SPRFarmTopology
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPRServer
  )
	
  foreach ($server in $SPRServer)
  {
    $computerName = Get-SPRComputerName -Address $server.Address
    $ipAddress = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -ComputerName $computerName |
    Where-Object -FilterScript {
      $_.IPAddress -ne $null
    } |
    Select-Object -ExpandProperty IPAddress
    $centralAdminServiceInstance = $server.ServiceInstances | Where-Object -FilterScript {
      $_.TypeName -eq 'Central Administration' -and ($_.Server.Name -eq $server.Address)
    }
    if ($centralAdminServiceInstance -ne $null)
    {
      $hostsCentralAdmin = $true
    }
    else
    {
      $hostsCentralAdmin = $false
    }
		
    $properties = [ordered]@{
      'Name'                = $computerName
      'IPAddress'           = $ipAddress
      'Role'                = $server.Role
      'CentralAdministration' = $hostsCentralAdmin
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
}
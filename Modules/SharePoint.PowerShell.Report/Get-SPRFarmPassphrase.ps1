function Get-SPRFarmPassphrase
{
  param
  (
    [Parameter(Mandatory = $false)]
    [object[]]$SPWebApplication
  )
	
    $properties = [ordered]@{
      'Passphrase'    = 'Get the passphrase'
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
}
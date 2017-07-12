function Get-SPRWebApplicationList
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPRWebApplication
  )
	
  foreach ($webApplication in $SPRWebApplication)
  {
    $properties = [ordered]@{
      'WebApplication' = $webApplication.DisplayName
      'Url'          = $webApplication.Url
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
}

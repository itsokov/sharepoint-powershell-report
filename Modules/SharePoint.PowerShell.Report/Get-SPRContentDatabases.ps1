function Get-SPRContentDatabases
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$spdatabase
  )
	
  $contentDatabases = $spdatabase | Where-Object -FilterScript {
    $_.Type -eq 'Content Database'
  }
	
  foreach ($contentDatabase in $contentDatabases)
  {
    $properties = [ordered]@{
      'Name'             = $contentDatabase.Name
      'Status'           = $contentDatabase.Status
      'Server'           = $contentDatabase.Server
      'WebApplication'   = $contentDatabase.WebApplication.Url
      'CurrentSiteCount' = $contentDatabase.CurrentSiteCount
      'WarningSiteCount' = $contentDatabase.WarningSiteCount
      'MaximumSiteCount' = $contentDatabase.MaximumSiteCount
      'AuthenticationType' = $xxx
      'ReadOnly'         = $contentDatabase.IsReadOnly
      'RecoveryModel'    = $xxx
      'TotalSize'        = $contentDatabase.DiskSizeRequired
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
}
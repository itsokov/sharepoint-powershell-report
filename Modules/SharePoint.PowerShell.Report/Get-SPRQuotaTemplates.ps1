function Get-SPRQuotaTemplates
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$Quotas
  )
   

    foreach ($Q in $Quotas){
    
    $properties = [ordered]@{
      'TemplateName'          = $Q.Name
      'StorageMaximumLevel'   = $Q.StorageMaximumLevel
      'StorageWarningLevel'   = $Q.StorageWarningLevel
      'InvitedUserMaximumLevel' = $Q.InvitedUserMaximumLevel
      'UserCodeMaximumLevel'  = $Q.UserCodeMaximumLevel
      'UserCodeWarningLevel'  = $Q.UserCodeWarningLevel
      #'WarningLevelEmail'     = $xxx
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
  
}
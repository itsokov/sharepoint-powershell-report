function Get-SPRWebApplicationsAndSiteCollections
{
  param
  (
    [parameter(Mandatory = $true)]
    [object[]]$SPRSite
		
  )
	
  foreach ($site in $SPRSite)
  {
    $siteAdmins = $site.RootWeb.SiteAdministrators | ForEach-Object -Process {
      ConvertTo-SPRLoginName -Login $_
    }
    $webApplication = $site.WebApplication
		
    $properties = [ordered]@{
      'WebApplication' = $webApplication.DisplayName
      'SiteCollection' = $site.Url
      'SiteAdmins'   = $siteAdmins
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
}
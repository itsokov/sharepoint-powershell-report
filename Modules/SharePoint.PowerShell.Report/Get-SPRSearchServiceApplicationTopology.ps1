function Get-SPRSearchServiceApplicationTopology
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$SPREnterpriseSearchServiceApplication
  )
  
  foreach ($searchServiceApplication in $SPREnterpriseSearchServiceApplication)
  {
    $serverGroups = $searchServiceApplication.SearchComponent | Group-Object -Property ServerID

    $output = @()
    foreach ($g in $serverGroups) 
    {
      $serverName = $g.Group | Select-Object -First 1 -ExpandProperty ServerName
      $properties = [ordered]@{
        'ServerName'                 = $serverName
        'AdminComponent'             = ($g.Group | Where-Object -FilterScript {
            $_.Name -like 'AdminComponent*'
        }) -ne $null
        'AnalyticsProcessingComponent' = ($g.Group | Where-Object -FilterScript {
            $_.Name -like 'AnalyticsProcessingComponent*'
        }) -ne $null
        'ContentProcessingComponent' = ($g.Group | Where-Object -FilterScript {
            $_.Name -like 'ContentProcessingComponent*'
        }) -ne $null
        'CrawlComponent'             = ($g.Group | Where-Object -FilterScript {
            $_.Name -like 'CrawlComponent*'
        }) -ne $null
        'IndexComponent'             = ($g.Group | Where-Object -FilterScript {
            $_.Name -like 'IndexComponent*'
        }) -ne $null
        'QueryProcessingComponent'   = ($g.Group | Where-Object -FilterScript {
            $_.Name -like 'QueryProcessingComponent*'
        }) -ne $null
      }
      $entry = New-Object -TypeName PSObject -Property $properties
      $output += $entry
    }
    Write-Output -InputObject $output
  }
}

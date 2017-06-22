function Export-SPREnterpriseSearchServiceApplicationConfiguration {
    param(
        [string]$Path
    )

    $file = '{0}\SPSearchServiceApplication.xml' -f $Path
    Start-Job -ScriptBlock {
        
        Add-PSSnapin -Name Microsoft.SharePoint.PowerShell

        $searchServiceApplications = Get-SPEnterpriseSearchServiceApplication
        $object = @()
        foreach ($searchServiceApplication in $searchServiceApplications)
        {
          $content = New-Object -TypeName Microsoft.Office.Server.Search.Administration.Content -ArgumentList $searchServiceApplication
          $crawlContentSource = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceApplication
          $searchServiceApplication | Add-Member -MemberType NoteProperty -Name 'Content' -Value $content
          $searchServiceApplication | Add-Member -MemberType NoteProperty -Name 'CrawlContentSources' -Value $crawlContentSource

          $object += $searchServiceApplication
        }

        $object | Export-Clixml -Path $args[0] -Depth 1
    } -ArgumentList $file

}
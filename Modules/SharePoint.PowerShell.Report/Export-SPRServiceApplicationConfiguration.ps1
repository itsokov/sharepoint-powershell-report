function Export-SPRServiceApplicationConfiguration {
    param(
        [string]$Path,
         [bool]$Async
    )

    $file = '{0}\SPRServiceApplication.xml' -f $Path
    $scriptBlock= {

    param($Path = $file)
    Write-Host -Object 'Exporting: Service Application Configuration. ' -NoNewline
        
        Add-PSSnapin -Name Microsoft.SharePoint.PowerShell

        $serviceApplications = Get-SPServiceApplication

        #@{l="Database";e={$_.Database.Name}},
        
        $output=@()
        foreach ($serviceApplication in $serviceApplications)
        {
        
            $object = $serviceApplication | select Name,Status, TypeName,@{l="ApplicationPool";e={$_.ApplicationPool.DisplayName}},@{l="ApplicationPoolAccount";e={$_.ApplicationPool.ProcessAccount.Name}}
            switch($serviceApplication.TypeName)
            {

                'User Profile Service Application'
                {
                    $propData = $serviceApplication.GetType().GetProperties([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)
 
                    $socialProp = $propData | where {$_.Name -eq "SocialDatabase"}
                    $SocialDatabase=$socialProp.GetValue($serviceApplication).Name
 
                    $profileProp = $propData | where {$_.Name -eq "ProfileDatabase"}
                    $ProfileDatabase=$profileProp.GetValue($serviceApplication).Name
 
                    $syncProp = $propData | where {$_.Name -eq "SynchronizationDatabase"}
                    $SynchronizationDatabase=$syncProp.GetValue($serviceApplication).Name
                    $allDatabases=$SocialDatabase+','+$ProfileDatabase+','+$SynchronizationDatabase+';'
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $allDatabases
                }
                'Search Service Application'
                {
                
                $crawlDatabases = Get-SPEnterpriseSearchCrawlDatabase -SearchApplication $serviceApplication
                $linksDatabases = Get-SPEnterpriseSearchLinksDatabase -SearchApplication $serviceApplication
                $analyticsDatabases = Get-SPServerScaleOutDatabase -ServiceApplication $serviceApplication
                $admindatabase = $serviceApplication.SearchAdminDatabase

                [string]$allDatabases=''
                foreach($crawlDatabase in $crawlDatabases)
                {
                    $allDatabases+=$crawlDatabase.Name
                    $allDatabases+=','
                
                }
                foreach($linksDatabase in $linksDatabases)
                {
                    $allDatabases+=$linksDatabase.Name
                    $allDatabases+=','
                
                }

                foreach($analyticsDatabase in $analyticsDatabases)
                {
                    $allDatabases+=$analyticsDatabase.Name
                    $allDatabases+=','
                
                }
                    $allDatabases+=$admindatabase.Name
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $allDatabases
                
                }
                'State Service'
                {
                
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $serviceApplication.databases.Name
                
                }
                'App Management Service Application'
                {
                
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value (Get-SPScaleOutDatabase -ServiceApplication $serviceApplication).Name
                
                }
                'Usage and Health Data Collection Service Application'
                {
                
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $serviceApplication.UsageDatabase.Name
                
                }
                'Secure Store Service Application'
                {
                
                    $propData = $serviceApplication.GetType().GetProperties([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)
                    $allDatabases = $propData | where {$_.Name -eq "Database"}
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $allDatabases.GetValue($serviceApplication).Name
                
                }
                'Microsoft SharePoint Foundation Subscription Settings Service Application'
                {
                    $propData = $serviceApplication.GetType().GetProperties([System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic)
                    $allDatabases = $propData | where {$_.Name -eq "Database"}
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $allDatabases.GetValue($serviceApplication).Name
                
                
                }

                default
                {
                    $object | Add-Member -MemberType NoteProperty -Name Database -Value $serviceApplication.database.Name
                }
            }
        
        $output+=$object
        }

        $output | Export-Clixml -Path $Path
    } 


  if($Async) 
  {
    Export-SPRObject -ScriptBlock $scriptblock -File $file -Async
  }
  else 
  {
    Export-SPRObject -ScriptBlock $scriptblock -File $file
  }


}
function Get-SPReport
{
  param
  (
    [parameter(Mandatory = $true)]
    [string]$ExportPath,
    [switch]$FromExportedFiles,
    [string]$ReportFilePath
  )
	
  if (-not $FromExportedFiles)
  {
    Export-SPRObjects -Path $ExportPath
  }
  $SPRObjects = Get-SPRObject -Path $ExportPath
	

  $title = 'Farm Overview'
  Write-Host -Object "Building section: $title"
  $report = Get-SPRFarmOverview -spfarm $SPRObjects.SPFarm -SPDatabases $SPRObjects.SPDatabase | 
  ConvertTo-EnhancedHTMLFragment -As List `
  -PreContent "<h2>$title</h2>" `
  -Properties FarmName, BuildVersion, SharePointLicense, ConfigurationDatabase, FarmServerCount
                                   
  $title = 'Servers in Farm'  
  Write-Host -Object "Building section: $title"                               
  $report += Get-SPRServersInFarm -spserver $SPRObjects.SPServer | 
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties ServerName, Role, OperatingSystem, Memory 
                                   
  $title = 'Web Applications and Site Collections' 
  Write-Host -Object "Building section: $title"                                
  $report += Get-SPRWebApplicationsAndSiteCollections -spsite $SPRObjects.SPSite |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, SiteCollection, SiteAdmins
                                   
  $title = 'Content Databases'     
  Write-Host -Object "Building section: $title"                            
  $report += Get-SPRContentDatabases -spdatabase $SPRObjects.SPDatabase |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Name
    
  $title = 'Farm Topology' 
  Write-Host -Object "Building section: $title"                                
  $report += Get-SPRFarmTopology -spserver $SPRObjects.SPServer -spserviceinstance $SPRObjects.SPServiceInstance |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Name, IPAddress, Role, ContralAdministration   
                                   
  $title = 'Site Topology'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRSiteTopology -spsite $SPRObjects.SPSite |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, SiteCollection, ContentDatabase     
                                   
  $title = 'Site Topology'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRSearchServiceApplicationTopology -SPEnterpriseSearchComponent $SPRObjects.SearchComponent|
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties AdminComponent, AnalyticsProcessingComponent, ContentProcessingComponent, CrawlComponent, IndexComponent, QueryProcessingComponent
                              
  $title = 'Services on Server'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRServicesOnServer -SPServer $SPRObjects.SPServer -SPServiceInstance $SPRObjects.SPServiceInstance |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties *

  $title = 'Web Application List'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationList -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, Url

  $title = 'Web Application General Settings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationGeneralSettings -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName, DefaultTimeZone, DefaultQuotaTemplate

           
  $title = 'Web Application Resource Throttling'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationResourceThrottling -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName, MaxItemsPerThrottledOperation, AllowOMCodeOverrideThrottleSettings, MaxQueryLookupFields, UnthrottledPrivilegedOperationWindowEnabled, MaxUniquePermScopesPerList, IsBackwardsCompatible, Days

                 
  $title = 'Web Application Workflow Settings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationWorkflowSettings -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName, AllowInternalUsers, AllowExternalUsers
      
                       
  $title = 'Web Application Features'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationFeatures -SPFeature $SPRObjects.SPFeature -SPwebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, FeatureName, CompatibilityLevel, IsActive
      
  $title = 'Web Application Managed Paths'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationManagedPaths -SPManagedPath $SPRObjects.SPManagedPath |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplicationUrl, Name, PrefixType

  $title = 'Web Application Self Service Site Creation'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationSelfServiceSiteCreation -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplicationName, WebApplicationUrl, Allowed, RequireSecondaryContact 
      
  $title = 'Web Application Web Part Security'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationWebPartSecurity -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName, OnlineWebPartGallery, WebPartConnections, ScriptableWebParts 
      
  $title = 'Web Application User Policy'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationUserPolicy -SPWebApplication $SPRObjects.SPWebApplication -SPManagedAccount $SPRObjects.SPManagedAccount |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName, UserDisplayName, Username, PolicyRoleBindings, SystemUser

  $title = 'Web Application Alternate Access Mappings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationAlternateAccessMappings -SPAlternateUrl $SPRObjects.SPAlternateURL |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties *
  
  $title = 'IIS Settings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRIISSettings -SPWebApplication $SPRObjects.SPWebApplication -SPAlternateURL $SPRObjects.SPAlternateURL -SPAuthenticationProvider $SPRObjects.SPAuthenticationProvider |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName,Url,Zone,Authentication,ApplicationPoolName,ApplicationPoolIdentity,SSL,ClaimsAuth,CEIP
  
  $title = 'Web Application Object Cache Accounts'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRWebApplicationObjectCacheAccounts -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DisplayName,SuperUserAcount,SuperUserHasFullControl,SuperReaderAcount,SuperReaderHasFullRead

  #region TsokovInput

  $title = 'Web Application Cross FireWall Access Zone'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRCrossFirewallAccessZone -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, CrossFirewallAccessZone 

   $title = 'Content Databases'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRContentDatabases -SPDatabase $SPRObjects.SPDatabase |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Name, Status, Server, WebApplication, CurrentSiteCount, WarningSiteCount, MaximumSiteCount, AuthenticationType, ReadOnly, RecoveryModel, TotalSize 
  
   $title = 'DATA RETRIEVAL SERVICES'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRDataRetrievalServices -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, InheritTheGlobalSettings, EnableTheseDataRetrievalServices, EnableUpdateQuerySupport, EnableTheseDataSourceControles, ResponseSizeLimit, RequestTimeOut 
  
   $title = 'Content Deployment Settings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRContentDeploymentSettings -SPContentDeploymentSettings $SPRObjects.SPContentDeploymentSettings|
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties AcceptIncomingJobs, ExportWebServer, ImportWebServer, TemporaryFolder, RequireSecureConnection

   $title = 'Diagnostic Logging Settings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRDiagnosticLoggingSettings -SPDiagConfig $SPRObjects.SPDiagnosticLogging |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties AllowLegacyTraceProviders, AppAnalyticsAutomaticUploadEnabled, CustomerExperienceImprovementProgramEnabled, DaysToKeepLogs, DownloadErrorReportingUpdatesEnabled, ErrorReportingAutomaticUploadEnabled, ErrorReportingEnabled, EventLogFloodProtectionEnabled, EventLogFloodProtectionNotifyInterval, EventLogFloodProtectionQuietPeriod, EventLogFloodProtectionThreshold, EventLogFloodProtectionTriggerPeriod, LogCutInterval, LogDiskSpaceUsageGB, LogLocation, LogMaxDiskSpaceUsageEnabled, ScriptErrorReportingDelay, ScriptErrorReportingEnabled, ScriptErrorReportingRequireAuth

  $title = 'DISTRIBUTED CACHE CONFIG'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRDistributedCacheConfig -SPCacheClusterConfig $SPRObjects.SPCacheClusterConfig -SPCacheHost $SPRObjects.SPCacheHost |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Host, Size, CachePort,ClusterPort,ReplicationPort,ArbitrationPort, Status


  $title = 'Document Conversions'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRDocumentConversions -SPWebApplication $SPRObjects.SPWebApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties WebApplication, Converter, Type, Timeout, MaxRetries, MaxFileSize

  
  $title = 'Event Throttling'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPREventThrottling -SPLogLevels $SPRObjects.SPLogLevel |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Name, EventSeverity, TraceSeverity

  $title = 'Farm Administrators'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRFarmAdministrators -SPFarmAdmins $SPRObjects.SPFarmAdmins |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Login,DisplayName

  $title = 'Antivirus Settings'    
  Write-Host -Object "Building section: $title"                             
  $report += Get-SPRFarmAntivirusSettings -SPWebServices $SPRObjects.SPWebServices |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties DownloadScanEnabled,UploadScanEnabled,AllowDownload,CleaningEnabled,Timeout,NumberOfThreads

  $title = 'QuotaTemplate'
  Write-Host -Object "Building section: $title"
  $report += Get-SPRQuotaTemplates -Quotas $SPRObjects.SPRQuota |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties TemplateName,StorageMaximumLevel,StorageWarningLevel,InvitedUserMaximumLevel,UserCodeMaximumLevel,UserCodeWarningLevel

   $title = 'SearchTopologies'
  Write-Host -Object "Building section: $title"
  $report += Get-SPRSearchTopologies -Topologies $SPRObjects.ActiveSearchTopology |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties ServiceApplication,Topology,CreationDate,State,ComponentCount,IsActive

   $title = 'SearchComponent'
  Write-Host -Object "Building section: $title"
  $report += Get-SPRSearchComponents -SearchComponents $SPRObjects.SearchComponent |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Name,Server,ServiceApplication,Topology,IsActive

  $title = 'SearchIndex'
  Write-Host -Object "Building section: $title"
  $report += Get-SPRSearchIndexPartitions -IndexPartitions $SPRObjects.SearchServiceApplication |
  ConvertTo-EnhancedHTMLFragment -As Table -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table' `
  -PreContent "<h2>$title</h2>" `
  -Properties Name,Server,ServiceApplication,Topology,RootDirectory,IndexLocation,Role,Service,Status

  #endregion
                 
  $css = @"
    body {
      font-family: Tahoma;
      font-size:10pt;
      background-color:white;
      color:#333;
    }

    .even {
      background-color:#eee;
    }
    
    .odd {
      background-color:#666;
    }

    .report-table {
      width: 100%;
    }
"@
  $date = Get-Date
  $reportTitle = "<h1>SharePoint Farm Report</h1><h2>$date</h2>"
  ConvertTo-EnhancedHTML -HTMLFragments $report -Title 'SharePoint Farm Report' -PreContent $reportTitle -CssStyleSheet $css -jQueryURI 'https://code.jquery.com/jquery-3.2.1.min.js' | Out-File -FilePath $ReportFilePath
}



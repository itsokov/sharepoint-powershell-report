function Get-SPRContentDeploymentSettings
{
	
$cs=[Microsoft.SharePoint.Publishing.Administration.ContentDeploymentConfiguration]::GetInstance()

if($cs.AcceptIncomingJobs)
{
    $properties = [ordered]@{
      'AcceptIncomingJobs' = $cs.AcceptIncomingJobs
      'ExportWebServer'     = $cs.ExportWebServer
      'ImportWebServer'=$cs.ImportWebServer
      'TemporaryFolder'=$cs.TemporaryFolder
      'RequireSecureConnection'=$cs.RequiresSecureConnection
      }
 }
 else{
     $properties = [ordered]@{
      'AcceptIncomingJobs' = $cs.AcceptIncomingJobs
      }
 }   
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
}
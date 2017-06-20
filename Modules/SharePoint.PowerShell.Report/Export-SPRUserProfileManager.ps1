function Export-SPRUserProfileManager
{
  param
  (
    [String]
    [Parameter(Mandatory)]
    $Path
  )
  
        $file = '{0}\SPUserProfileManager.xml' -f $Path
        Start-Job -ScriptBlock {
        
        Add-PSSnapin -Name Microsoft.SharePoint.PowerShell

        $webAppUrl=Get-SPWebApplication -IncludeCentralAdministration | select -First 1  | select -ExpandProperty URL
        $sc = Get-SPServiceContext($webAppUrl)
        $userProfileManager = new-object Microsoft.Office.Server.UserProfiles.UserProfileManager($sc)
        
        $userProfileManager | Export-Clixml -Path $args[0]
    } -ArgumentList $file
}
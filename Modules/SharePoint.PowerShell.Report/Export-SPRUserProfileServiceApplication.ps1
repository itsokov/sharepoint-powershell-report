function Export-SPRUserProfileServiceApplication
{
  param(
    [string]$Path
  )

  $file = '{0}\SPServiceApplicationUserProfiles.xml' -f $Path
  Start-Job -Name '' -ScriptBlock {
    Add-PSSnapin -Name Microsoft.SharePoint.PowerShell
    $Object = Get-SPServiceApplication | Where-Object {$_.TypeName -like "*User Profile Service Application*"}

    $object | Export-Clixml -Path $args[0]
    
  } -ArgumentList $file
}

﻿function Export-SPRManagedAccount
{
  param(
    [string]$Path,
    [bool]$Async
  )

  $file = '{0}\SPRManagedAccount.xml' -f $Path
  
  $scriptblock = {
    param($Path = $file)
    Add-PSSnapin -Name Microsoft.SharePoint.PowerShell
    Write-Host -Object 'Exporting: Managed Account Configuration. ' -NoNewline

    $output = Get-SPManagedAccount
    $output | Export-Clixml -Path $Path
      
    Write-Host -Object ' Done.'
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

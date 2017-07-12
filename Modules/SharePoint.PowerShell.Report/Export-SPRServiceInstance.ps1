function Export-SPRServiceInstance
{
  param(
    [string]$Path,
    [bool]$Async
  )

  $file = '{0}\SPRServiceInstance.xml' -f $Path
    
  $scriptblock = {
    param($Path = $file)
    Add-PSSnapin -Name Microsoft.SharePoint.PowerShell
    Write-Host -Object 'Exporting: Service Instance Configuration. ' -NoNewline

    $output = Get-SPserviceInstance
    $output | Export-Clixml -Path $Path -Depth 1

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

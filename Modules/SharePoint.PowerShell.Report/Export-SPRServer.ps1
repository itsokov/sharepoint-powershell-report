function Export-SPRServer
{
  param(
    [string]$Path,
    [bool]$Async
  )

  $file = '{0}\SPRServer.xml' -f $Path
    
  $scriptblock = {
    param($Path = $file)
    Add-PSSnapin -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
    Write-Host -Object 'Exporting: Server Configuration. ' -NoNewline

    $output = @()

    $servers = Get-SPServer
    foreach ($server in $servers)
    {
      $serviceInstances = Get-SPServiceInstance -Server $server
      $server | Add-Member -MemberType NoteProperty -Name 'ServiceInstances' -Value $serviceInstances -ErrorAction SilentlyContinue
      
      $output += $server
    }
        
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

function Export-SPRFeature 
{
  param(
    [string]$Path,
    [bool]$Async
  )

  $file = '{0}\SPRFeature.xml' -f $Path
  
  $scriptblock = {
    param($Path = $file)
    Add-PSSnapin -Name Microsoft.SharePoint.PowerShell
    Write-Host -Object 'Exporting: Service Instance Configuration. ' -NoNewline

    $output = @()
      
    $features = Get-SPFeature
    foreach ($feature in $features)
    {
      $featureTitleEN = $feature.GetTitle(1033)
      $feature.Title
      $feature | Add-Member -MemberType NoteProperty -Name 'Title' -Value $featureTitleEN
      $output += $feature
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

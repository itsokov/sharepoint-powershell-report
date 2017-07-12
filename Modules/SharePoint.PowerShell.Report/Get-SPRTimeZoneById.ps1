function Get-SPRTimeZoneById 
{
  param(
    [int]$Id
  )

  [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SharePoint')
  $description = [Microsoft.SharePoint.SPregionalSettings]::GlobalTimeZones | Where-Object -FilterScript {$_.ID -eq $Id} | Select-Object -ExpandProperty Description
  if($description -eq $null)
  {
    [string]$output = '(none)'
  } else {
    [string]$output = $description
  }

  Write-Output -InputObject $output
}

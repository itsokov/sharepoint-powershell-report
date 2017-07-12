function Get-SPReportFragment
{
  param
  (
    [String]
    [Parameter(Mandatory)]
    $Title,
    [object]
    [Parameter(Mandatory)]
    $Object,
    [object]
    [Parameter(Mandatory)]
    $Properties,
    [switch]
    $AsList
    
  )
  if ($AsList)
  {
    $output = $Object | ConvertTo-EnhancedHTMLFragment -As List -PreContent "<h2>$Title</h2>" -Properties $Properties
  } else 
  {
    $output = $Object | ConvertTo-EnhancedHTMLFragment -As Table -PreContent "<h2>$Title</h2>" -Properties $Properties -EvenRowCssClass 'even' -OddRowCssClass 'odd' -TableCssClass 'report-table'
  }
  Write-Output -InputObject $output
}

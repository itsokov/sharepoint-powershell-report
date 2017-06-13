function Get-SPRSearchTopologies
{
  param
  (
    [Parameter(Mandatory = $true)]
    [object[]]$Topologies
  )


  foreach ($Topology in $Topologies)
  {
    $properties = [ordered]@{
      'ServiceApplication' = $Topology.Name
      'Topology'         = $Topology.TopologyId
      'CreationDate'     = $Topology.CreationDate
      'State'            = $Topology.State
      'ComponentCount'   = $Topology.ComponentCount
      'IsActive'         = $Topology.State
    }
    $output = New-Object -TypeName PSObject -Property $properties
		
    Write-Output -InputObject $output
  }
}
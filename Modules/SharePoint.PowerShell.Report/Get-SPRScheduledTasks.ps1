function Get-SPRScheduledTasks
{
  $tasks = Get-ScheduledTask
  foreach ($t in $tasks)
  {
	#this check is added so that we do not display the default microsoft windows scheduled tasks
	if (-Not ($t.taskpath.Contains('Microsoft\Windows'))) {
		$properties = [ordered]@{
		  'TaskName' = $t.TaskName
		  'State'     = $t.State
		  'Description'     = $t.Description
		  'Source'     = $t.Source
		  'URI'     = $t.URI
		  'Version'     = $t.Version
		}
		$output = New-Object -TypeName PSObject -Property $properties
		
		Write-Output -InputObject $output
	}
  }
}
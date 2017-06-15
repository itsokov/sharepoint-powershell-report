function Export-SPRSolution {
    param(
        [string]$Path
    )

    $file = '{0}\SPSolution.xml' -f $Path
    Start-Job -ScriptBlock {
        
        Add-PSSnapin -Name Microsoft.SharePoint.PowerShell
        $objects = Get-SPSolution
        $objects | Export-Clixml -Path $args[0]
    } -ArgumentList $file
}
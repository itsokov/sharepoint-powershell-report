function Export-SPRObject {
    param(
        [scriptblock]$ScriptBlock,
        [string]$File,
        [switch]$Async
    )

    if($Async) {
        Invoke-Command -ScriptBlock $scriptblock -ArgumentList $File -AsJob -ComputerName $env:COMPUTERNAME
    } else {
        Invoke-Command -ScriptBlock $scriptblock -ArgumentList $File
    }

}
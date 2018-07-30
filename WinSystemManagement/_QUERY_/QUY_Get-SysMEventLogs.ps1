#Requires -Version 4.0

<#
.SYNOPSIS
    Retrieves the event logs on the computer

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinSystemManagement/_QUERY_

.Parameter ComputerName
    Specifies remote computer, the default is the local computer
#>

[CmdLetBinding()]
Param(
    [string]$ComputerName
)

try{
    if([System.String]::IsNullOrWhiteSpace($ComputerName)){
        $ComputerName = "."
    }   
    if($SRXEnv) {
        $SRXEnv.ResultList =@()
        $SRXEnv.ResultList2 =@()
    }
    $Script:logs = Get-EventLog -ComputerName $ComputerName -List -ErrorAction Stop | Select-Object *
    foreach($item in $Script:logs)
    {
        if($SRXEnv) {
            $SRXEnv.ResultList += $item.Log
            $SRXEnv.ResultList2 += $item.LogDisplayName # Display
        }
        else{
            Write-Output $item.LogDisplayName
        }
    }
}
catch{
    throw
}
finally{
}
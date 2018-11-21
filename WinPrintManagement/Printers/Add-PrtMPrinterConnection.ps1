#Requires -Version 4.0
#Requires -Modules PrintManagement

<#
.SYNOPSIS
    Adds connection to network-based printer

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT
    Requires Module PrintManagement

.LINK
    https://github.com/scriptrunner/ActionPacks/tree/master/WinPrintManagement/Printers

.Parameter ConnectionName
    Specifies the name of a shared printer to which to connect    
#>

   
[CmdLetBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$ConnectionName
)

Import-Module PrintManagement

$Script:Output=@()
try{
    Add-Printer -ConnectionName $ConnectionName -ErrorAction Stop
    $Script:Output += "Add printer: $($ConnectionName) succeeded"
    if($SRXEnv) {
        $SRXEnv.ResultMessage = $Script:Output
    } 
    else {
        Write-Output $Script:Output   
    }    
}
catch{
    Throw 
}
finally{
}
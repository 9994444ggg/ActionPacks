#Requires -Version 5.0
#Requires -Modules SQLServer

<#
.SYNOPSIS
    Gets a job schedule objects 

.DESCRIPTION

.NOTES
    This PowerShell script was developed and optimized for ScriptRunner. The use of the scripts requires ScriptRunner. 
    The customer or user is authorized to copy the script from the repository and use them in ScriptRunner. 
    The terms of use for ScriptRunner do not apply to this script. In particular, AppSphere AG assumes no liability for the function, 
    the use and the consequences of the use of this freely available script.
    PowerShell is a product of Microsoft Corporation. ScriptRunner is a product of AppSphere AG.
    © AppSphere AG

.COMPONENT
    Requires Module SQLServer
    Requires the library script DMSSqlServer.ps1
    
.LINK
    https://github.com/scriptrunner/ActionPacks/blob/master/DBSystems/_QUERY_
 
.Parameter ServerInstance
    Specifies the name of the target computer including the instance name, e.g. MyServer\Instance 

.Parameter ServerCredential
    Specifies a PSCredential object for the connection to the SQL Server. ServerCredential is ONLY used for SQL Logins. 
    When you are using Windows Authentication you don't specify -Credential. It is picked up from your current login.

.Parameter ConnectionTimeout
    Specifies the time period to retry the command on the target server
#>

[CmdLetBinding()]
Param(  
    [Parameter(Mandatory = $true)]   
    [string]$ServerInstance,    
    [pscredential]$ServerCredential,
    [int]$ConnectionTimeout = 30
)

Import-Module SQLServer

try{
    [hashtable]$cmdArgs = @{'ErrorAction' = 'Stop'
                            'Confirm' = $false
                            'ServerInstance' = $ServerInstance
                            'ConnectionTimeout' = $ConnectionTimeout}
    if($null -ne $ServerCredential){
        $cmdArgs.Add('Credential',$ServerCredential)
    }
    $instance = Get-SqlInstance @cmdArgs

    if($SRXEnv) {
        $SRXEnv.ResultList =@()
        $SRXEnv.ResultList2 =@()
    }
    $result = Get-SqlAgent -InputObject $instance -ErrorAction Stop | `
                            Get-SqlAgentJob | Get-SqlAgentJobSchedule | Select-Object Name,Parent
    
    foreach($itm in  $result){
        if($SRXEnv) {            
            $SRXEnv.ResultList += $itm.Name # Value
            $SRXEnv.ResultList2 += "Schedule: $($itm.Name) - Job: $($itm.Parent)"
        }
        else{
            Write-Output "Schedule: $($itm.Name) - Job: $($itm.Parent)"
        }
    }
}
catch{
    throw
}
finally{
}
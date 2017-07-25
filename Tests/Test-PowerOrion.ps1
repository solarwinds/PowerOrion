Set-Location C:\projects\PowerOrion\Tests

if (Get-PSSnapin -Name SwisSnapin -ErrorAction SilentlyContinue){
  remove-PSSnapin SwisSnapin
}
#silence issues relating to snapins being called from modules
try
{
  add-PSSnapin SwisSnapin  -ErrorVariable $SwisError
 }
 catch{}


$settings = Get-Content "$PSScriptRoot\PesterConfig.json" |  ConvertFrom-Json 
$user = $settings.User
$password=$settings.Password
$Global:OrionServer = $settings.OrionServer
$Global:ModPath = $settings.ModulePath

#Import-Module -name $ModPath -Force 
$global:swis = Connect-Swis -UserName $user -Password $password -Hostname $OrionServer

 try{
        Write-Verbose "Verifying connection to Orion."

        $swis.Open()
    }
    catch{
        Write-Error $_.Exception.Message
    }


Invoke-Pester -Tag Readonly

set-location ..

Invoke-ScriptAnalyzer -Path C:\projects\PowerOrion

if (Get-PSSnapin -Name SwisSnapin -ErrorAction SilentlyContinue){
  remove-PSSnapin SwisSnapin
}
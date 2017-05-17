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
$OrionServer = $settings.OrionServer
$ModPath = $settings.ModulePath

Import-Module -name $ModPath -Force 
$global:swis = Connect-Swis -UserName $user -Password $password -Hostname $OrionServer

Invoke-Pester 

<#foreach ($file in Get-ChildItem -Path ..\Public\*.ps1){
    Invoke-Pester -CodeCoverage $file 
    }

#>
if (Get-PSSnapin -Name SwisSnapin -ErrorAction SilentlyContinue){
  remove-PSSnapin SwisSnapin
}
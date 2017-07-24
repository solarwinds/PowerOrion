<#
    .Synopsis
    Returns the properties, or the custom properties, of a node monitored by Orion
    .DESCRIPTION
    This Cmdlet returns the properties of a node monitored by Orion. It can look up a node based on it's node id. If this is not explicitly available, it can call Get-OrionNodeID
    If passed the  -custom switch it can return

    .EXAMPLE
    Get-OrionNodeProperties -SwisConnection $swis -NodeID $nodeid   

    .EXAMPLE
     Get-OrionNodeProperties -SwisConnection $swis  -NodeID $nodeid  -custom

    Key                                Value
    ---                                -----
    NodeID                             3
    City                               Austin
    IsMissionCritical                  False

#>
function Get-OrionInstalledModules
{
  [CmdletBinding()]
  [OutputType([psobject])]
  Param
  (
    #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection
  )
  begin
  {
    $query = 'SELECT LicenseName, Version FROM Orion.InstalledModule ORDER BY Name'
  
  }
  process
  {
    $result = Get-SwisData -Query $query -SwisConnection $SwisConnection
  
  }
  end
  {
    Write-Output $result
  
  }
  
}
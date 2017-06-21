<#
    .Synopsis
    Adds a new poller to a node in Orion
    .DESCRIPTION
    This cmdlet addes new pollers (CPU, memory, uptime etc) to nodes in Orion
    .EXAMPLE
    New-OrionPollerType -PollerType "N.ResponseTime.ICMP.Native" -NodeProperties $nodeProps -SwisConnection $SwisConnection

#>
function New-OrionPollerType
{ 
  [CmdletBinding()]
  [OutputType([int])]
  Param
  (
    # The type of poller to add (e.g. N.IPAddress.ICMP.Generic)
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
    Position=0)]
    $PollerType ="N.IPAddress.ICMP.Generic",

    # Node Properties used to build the pollers
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
    Position=1)]
    $NodeProperties,

    #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection
  )

  Begin
  {
    Write-Verbose "Starting $($myinvocation.mycommand)"  
    $poller = @{
      NetObject="N:"+$NodeProperties["NodeID"];
      NetObjectType="N";
      NetObjectID=$NodeProperties["NodeID"];
    }
    $id = $NodeProperties["NodeID"];
  }
  Process
  {
    $poller["PollerType"]=$PollerType;
    $pollerUri = New-SwisObject $SwisConnection -EntityType "Orion.Pollers" -Properties $poller
        
  }
  End
  {
    write-verbose " A $PollerType was added for node ID  $id"
    Write-Verbose "Finishing $($myinvocation.mycommand)"
    return $pollerUri
  }
}
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
    [ValidateSet("N.IPAddress.ICMP.Generic",
        "N.ResponseTime.ICMP.Native",
        "N.Status.ICMP.Native",
        "N.Details.SNMP.Generic",
        "N.Uptime.SNMP.Generic",
        "N.Cpu.SNMP.CiscoGen3",
        "N.Memory.SNMP.CiscoGen3",
        "N.IPAddress.SNMP.Generic",
        "N.Details.WMI.Vista",
        "N.Uptime.WMI.XP", 
        "N.Cpu.WMI.Windows",
        "N.Memory.WMI.Windows",
        "N.AssetInventory.Snmp.Generic",
        "N.AssetInventory.WMI.Generic")]
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
<#
    .Synopsis
    Returns the Node ID for a given node managed in Orion
    .DESCRIPTION
    This CmdLet returns the Node ID for a given node managed in Orion, by looking up either the node name or IP Address. 
   
    .EXAMPLE
    Get-OrionNodeID -node "lab-hpinsight" -swisconnection $swis
    .EXAMPLE
    Get-OrionNodeID -IPAddress 10.199.1.100 -SwisConnection $swis
    .EXAMPLE 
    $swis = Connect-Swis -UserName admin -Password "" -Hostname 10.160.5.75
    Get-OrionNodeID -Node $TestNode -SwisConnection $swis
    
    3
                                                                                                        
 
#>
function Get-OrionNodeID
{
  [CmdletBinding()]
  [OutputType([int])]
  Param
  (
   
    #The Caption or Nodename used to reference the entity
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=0,
    Parametersetname="Name")]
    [validatenotnullorempty()]
    [alias("Node","Caption")]
    [string]
    $NodeName,

    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=0,
    Parametersetname="IP")]
    [validatenotnullorempty()]
    [alias("IP")]
    [String]$IPAddress,
        
    #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection
  )

  Begin
  {
    Write-Verbose "Starting $($myinvocation.mycommand)"  
  }
  Process
  {   
    
      if ($NodeName){
        write-verbose " Querying Orion Server for Node ID for $NodeName"
        $NodeID = Get-SwisData $SwisConnection "SELECT NodeID FROM Orion.Nodes WHERE Caption=@n" @{n=$NodeName}
      } else
      {
        write-verbose " Querying Orion Server for Node ID for $IPAddress"
        $NodeID = Get-SwisData $SwisConnection "SELECT top 1 NodeID FROM Orion.Nodes WHERE IP_Address=@ip" @{ip=$IPAddress}
        
      }
      
      if(-not $NodeID){
        Write-Error "No Node Id found"
      }
   
  }
  End
  {
    Write-Verbose "Finishing $($myinvocation.mycommand)"
    Return $NodeID
  }
}
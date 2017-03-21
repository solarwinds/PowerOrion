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
function Get-OrionNode
{
  [CmdletBinding()]
  [OutputType([psobject])]
  Param
  (
    #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection,
        
    [Parameter(ValueFromPipelineByPropertyName=$true,
    Parametersetname="ID")]
        
    [validatenotnullorempty()]
    [alias("ID")]
    [int32]
    $NodeID,
      
    #The IP Address of the node
    [Parameter(ValueFromPipelineByPropertyName=$true,
    Parametersetname="IP")]
    [String]$IPAddress,




    #Returns custom properties if set
    [switch]
    [alias('custom')]
    $customproperties
  )

  Begin
  {
    Write-Verbose "Starting $($myinvocation.mycommand)"  
    $OrionServer = Get-OrionHostFromSwisConnection -swisconnection $SwisConnection
    write-debug " The value of OrionServer is $OrionServer"

    if($IPAddress){
      write-debug " The value of IPAddress is $IPAddress"
      write-verbose " IP passed, calling Get-OrionNodeID for $IPAddress"
      $ID = Get-OrionNodeID -IPAddress $IPAddress -SwisConnection $SwisConnection
    }else {
            
      write-debug " The value of ID is $NodeID"
      write-verbose " Integer passed"
      $ID = $NodeID           
    }
           
        
    if ($customproperties){
      $uri = "swis://$OrionServer/Orion/Orion.Nodes/NodeID=$ID/CustomProperties"
    } else {
      $uri = "swis://$OrionServer/Orion/Orion.Nodes/NodeID=$ID"
    }
    Write-Debug " The URI is $uri"
  }
  Process
  {
    Write-Verbose " Getting properties at $uri"
    $nodeProps = Get-SwisObject $SwisConnection -Uri $uri
    $properties = New-Object -TypeName psobject -Property $nodeProps
    write-debug " The value of nodeprops is $nodeProps"
    write-debug " The value of properties is $($properties.gettype())"
  }
  End
  {        
    Write-Verbose "Finishing $($myinvocation.mycommand)"
    Write-Output $properties
  }
}
<#
    .Synopsis
    Add a new node to Orion
    .DESCRIPTION
    This cmdlet adds a new node to Orion. The default is an ICMP node, future versions will include SNMP and WMI options
    .EXAMPLE
    New-OrionNode -SwisConnection $swis -IPAddress "10.160.5.83" 
    .EXAMPLE
    $cred = get-OrionWMICredential -SwisConnection $swis | where-Object {$_.Name  -like "Local Admin 2"}
    New-OrionNode -SwisConnection $swis -ObjectSubType WMI -IPAddress 10.160.5.85 -CredentialID $cred.id -Verbose 
#>
function New-OrionNode
{
  [CmdletBinding(
      SupportsShouldProcess=$True
  )]
  [OutputType([int])]
  Param
  (
    #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection,
        
    [parameter()]
    [validatenotnullorempty()]
    [ValidateSet("ICMP","SNMPv2","WMI")]
    $ObjectSubType="ICMP",

    #The IP address of the node to be added for monitoring
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
        Position=0,
    Parametersetname="IP")]        
    [Alias("IP")]
    [String]$IPAddress,

    #The IP address of the node to be added for monitoring
    [Parameter(Mandatory=$true,
        Position=0,
    Parametersetname="NodeName")]
    [String]$NodeName,

    #The Polling Engine to add the node to (default = 1)
    [parameter()]
    [validatenotnullorempty()]
    [int32]$engineid=1,

    #The Status of the device (default = 1)
    [parameter()]
    [Alias("Credential","ID")]
    [int32]$CredentialID,

    #The Status of the device (default = 1)
    [parameter()]
    [validatenotnullorempty()]
    [int32]$status=1,

    #Whether the device is Unmanaged or not (default = false)
    [parameter()]
    [validatenotnullorempty()]
    $UnManaged=$false,
        
    [parameter()]
    [validatenotnullorempty()]
    $DynamicIP=$false,

    [parameter()]
    [validatenotnullorempty()]
    $Allow64BitCounters=$true,

    [parameter()]
    [validatenotnullorempty()]
    $Community="public"
  )

  Begin{
        
    Write-Verbose "Starting $($myinvocation.mycommand)"  
        
    #$ipGuid = Convert-ip2OrionGuid($IPAddress)
    $ipguid = [guid]::NewGuid()
        
    Switch($ObjectSubType)
    {
      "ICMP"{ # add a node
        $newNodeProps = @{
          EntityType="Orion.Nodes";
          IPAddress=$IPAddress;
          IPAddressGUID=$ipGuid;
          Caption=$IPAddress;
          DynamicIP=$DynamicIP;
          EngineID=$engineid;
          Status=$status;
          UnManaged=$UnManaged;
          Allow64BitCounters=$Allow64BitCounters;
          SysObjectID="";
          MachineType="";
          SysName="";
          External="";
          NodeDescription="";
          Location="";
          Contact="";
          IOSImage="";
          IOSVersion=""; 
          Vendor="Unknown";
          VendorIcon="Unknown.gif";
          PercentMemoryUsed="0";
          ObjectSubType="ICMP";                     
        }

        #next define the poller 
        $PollerTypes = @("N.IPAddress.ICMP.Generic","N.ResponseTime.ICMP.Native","N.Status.ICMP.Native")

      }#end of ICMP
                
      "SNMPv2"{ # add a node
        $newNodeProps = @{
          EntityType="Orion.Nodes";
          IPAddress=$IPAddress;
          IPAddressGUID=$ipGuid;
          Caption=$IPAddress;
          DynamicIP=$DynamicIP;
          EngineID=$engineid;
          Status=$status;
          UnManaged=$UnManaged;
          Allow64BitCounters=$Allow64BitCounters;
          Location = "";
          Contact = "";
          NodeDescription="";
          Vendor="";
          IOSImage="";
          IOSVersion="";
          SysObjectID="";
          MachineType="";
          VendorIcon="";
          # SNMP v2 specific
          ObjectSubType="SNMP";
          SNMPVersion=2;
          Community=$Community;
          BufferNoMemThisHour="-2"; 
          BufferNoMemToday="-2"; 
          BufferSmMissThisHour="-2"; 
          BufferSmMissToday="-2"; 
          BufferMdMissThisHour="-2"; 
          BufferMdMissToday="-2"; 
          BufferBgMissThisHour="-2"; 
          BufferBgMissToday="-2"; 
          BufferLgMissThisHour="-2"; 
          BufferLgMissToday="-2"; 
          BufferHgMissThisHour="-2"; 
          BufferHgMissToday="-2"; 
          PercentMemoryUsed="-2"; 
          TotalMemory="-2";                     
        }

                

        #next define the pollers 
        $PollerTypes = @("N.Details.SNMP.Generic","N.Uptime.SNMP.Generic","N.Cpu.SNMP.CiscoGen3","N.Memory.SNMP.CiscoGen3", "N.IPAddress.SNMP.Generic")

      }#end of SNMPv2
      "WMI"{ # add a node
        $newNodeProps = @{
          EntityType="Orion.Nodes";
          IPAddress=$IPAddress;
          IPAddressGUID=$ipGuid;
          Caption="";
          DynamicIP=$DynamicIP;
          EngineID=$engineid;
          Status=$status;
          UnManaged=$UnManaged;
          Allow64BitCounters=$Allow64BitCounters;
          Location = "";
          Contact = "";
          NodeDescription="";
          Vendor="";
          IOSImage="";
          IOSVersion="";
          SysObjectID="";
          MachineType="";
          VendorIcon="";
          # WMI specific
          ObjectSubType="WMI";
          SNMPVersion=0;
          Community="";
          BufferNoMemThisHour="-2"; 
          BufferNoMemToday="-2"; 
          BufferSmMissThisHour="-2"; 
          BufferSmMissToday="-2"; 
          BufferMdMissThisHour="-2"; 
          BufferMdMissToday="-2"; 
          BufferBgMissThisHour="-2"; 
          BufferBgMissToday="-2"; 
          BufferLgMissThisHour="-2"; 
          BufferLgMissToday="-2"; 
          BufferHgMissThisHour="-2"; 
          BufferHgMissToday="-2"; 
          PercentMemoryUsed="-2"; 
          TotalMemory="-2";  
                                                                              
        }
        #check to make sure there is a valid credential ID  
        if(!$CredentialID) {
          $CredentialID = "Please enter the ID of the Orion WMI Credential to be used" 
        }

        #next define the pollers 
        $PollerTypes = @("N.Status.ICMP.Native","N.ResponseTime.ICMP.Native","N.Details.WMI.Vista","N.Uptime.WMI.XP", "N.Cpu.WMI.Windows","N.Memory.WMI.Windows")
      } #end of WMI

    }#end of switch
        
  }
  Process
  {
    write-verbose "Adding $IPAddress to Orion Database"
    If ($PSCmdlet.ShouldProcess("$IPAddress","Add Node")) {
      $newNode = New-SwisObject $SwisConnection -EntityType "Orion.Nodes" -Properties $newNodeProps 
      $nodeProps = Get-SwisObject $SwisConnection -Uri $newNode
                
      #Add credentials for WMI nodes
      if($ObjectSubType = "WMI"){
        #Adding NodeSettings
        $nodeSettings = @{
          NodeID=$nodeProps["NodeID"];
          SettingName="WMICredential";
          SettingValue=($CredentialID.ToString());
        }
        write-debug "Node Settings:  $nodeSettings"
        write-debug "New Node:  $newNode"
        Write-Verbose "Adding WMI Credentials"

        #Creating node settings
        $newNodeSettings = New-SwisObject $SwisConnection -EntityType "Orion.NodeSettings" -Properties $nodeSettings
        Write-Debug "New Node Settings : $newNodeSettings"
      } #end of WMI nodes

    }
        
    write-verbose "Node added with URI = $newNode"

    write-verbose "Now Adding pollers for the node..." 
    $nodeProps = Get-SwisObject $SwisConnection -Uri $newNode
    #Loop through all the pollers 
    foreach ($PollerType in $PollerTypes){
      If ($PSCmdlet.ShouldProcess("$PollerTypes","Add Poller")) {
        New-OrionPollerType -PollerType $PollerType -NodeProperties $nodeProps -SwisConnection $SwisConnection
      }          
    }    
  }
  End
  {
    Write-Output "$newNode"
    Write-Verbose "Finishing $($myinvocation.mycommand)"
  }
}
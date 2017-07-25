<#
.Synopsis
   Test if Orion node has a hardware health monitoring enabled
.DESCRIPTION
   Takes an array of node IDs, and checks using the IsHardwareHealthEnabled  verb, if hardware health is enabled
.EXAMPLE
  Test-OrionHardwareHealthEnabled -SwisConnection $swis -NodeID 3,5 
  HardwareEnabled node
--------------- ----
           True 3   
          False 5 

#>
function Test-OrionHardwareHealthEnabled
{
    [CmdletBinding()]
    [Alias()]
    
    Param
    (
    #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection,
        
    [parameter(mandatory=$true)]   
    [validatenotnullorempty()]
    [int32[]]
    $NodeID
    )

    Begin
    {
      $results = @()
    }
    Process
    {
        foreach ($node in $NodeID){
          write-verbose "Checking Node ID:$node for hardware health"
          $RawResult = Invoke-SwisVerb -EntityName Orion.HardwareHealth.HardwareInfo -Verb IsHardwareHealthEnabled -arguments @("N:$Node") -SwisConnection $SwisConnection
          $filtered = $RawResult | Select-Object '#text'
          write-debug "The result is $filtered"
          if ($filtered.'#text'){
            $check = @{'node'="$Node"
                          'HardwareEnabled'=$true}
          }
          else{
              $check = @{'node'="$Node"
                            'HardwareEnabled'=$false}
          }
          $results += New-Object PSobject -Property $check
        }
    }
    End
    {
      Write-Output $results
    }
}



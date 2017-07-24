<#
.Synopsis
   Removes Nodes from Orion Server
.DESCRIPTION
   Takes either URIs or Nodeids of nodes to remove from an orion server
.EXAMPLE
   remove-OrionNode -SwisConnection $swis -NodeID 1,7,8,9
    swis://OrionVM./Orion/Orion.Nodes/NodeID=1
    swis://OrionVM./Orion/Orion.Nodes/NodeID=7
    swis://OrionVM./Orion/Orion.Nodes/NodeID=8
    swis://OrionVM./Orion/Orion.Nodes/NodeID=9
.EXAMPLE
   remove-OrionNode -SwisConnection $swis -NodeID 11,12 -Confirm
    Delete performed on: swis://OrionVM./Orion/Orion.Nodes/NodeID=11 swis://OrionVM./Orion/Orion.Nodes/NodeID=12
.EXAMPLE
  $uris = "swis://OrionVM./Orion/Orion.Nodes/NodeID=15","swis://OrionVM./Orion/Orion.Nodes/NodeID=16"
  remove-OrionNode -SwisConnection $swis -URI $uris -whatif
  What if: Performing the operation "calling remove-swisobject" on target "swis://OrionVM./Orion/Orion.Nodes/NodeID=15 swis://OrionVM./Orion/Orion.Nodes/NodeID=16".
  Delete performed on: swis://OrionVM./Orion/Orion.Nodes/NodeID=15 swis://OrionVM./Orion/Orion.Nodes/NodeID=16

.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Remove-OrionNode
{
    [CmdletBinding(DefaultParameterSetName='URI', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'https://github.com/solarwinds/PowerOrion',
                  ConfirmImpact='Medium')]
    
    [OutputType([String])]
    Param
    (
        #SolarWinds Information Service (SWIS) Connection
    [parameter(mandatory=$true)]
    [validatenotnullorempty()]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $SwisConnection,    
    
    # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='URI')]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $URI,

        # Param2 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,ParameterSetName='NodeID')]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $NodeID
    )

    Begin
    {
      $nodes = @()
      if ($NodeID){
        Write-Verbose "NodeId Selected"
        foreach($id in $NodeID){
          $nodes += Get-OrionNode -SwisConnection $SwisConnection -NodeID $id | Select-Object -ExpandProperty uri
        }
      } 
      else{
        write-verbose "URIs passed"
        $nodes = $URI
      }
      Write-Debug "Contents of nodes is $nodes"
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("$nodes", 'calling remove-swisobject'))
        {
          $nodes | Remove-SwisObject -SwisConnection $SwisConnection 
        }
    }
    End
    {
        Write-Output "Delete performed on: $nodes"
    }
}

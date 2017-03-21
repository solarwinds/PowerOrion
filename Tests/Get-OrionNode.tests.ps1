# this is a Pester test file

#. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

# initialize SWIS connection 
if (Get-PSSnapin -Name SwisSnapin -ErrorAction SilentlyContinue){
  remove-PSSnapin SwisSnapin
}
Add-PSSnapin SwisSnapin 
$MyInvocation.PSScriptRoot
$settings = Get-Content "$PSScriptRoot\PesterConfig.json" |  ConvertFrom-Json 
$user = $settings.User
$password=$settings.Password
$OrionServer = $settings.OrionServer
$swis = Connect-Swis -UserName $user -Password $password -Hostname $OrionServer


#endregion

#describes the function Get-OrionNodeID
Describe 'Get-OrionNode' {

  # scenario 1: call the function without arguments
  Context 'Running with -IPAddress'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionNode -IPAddress '192.168.100.2' -SwisConnection $swis} | Should Not Throw
    }
    It 'returns an  object ' {
      (Get-OrionNode -IPAddress '192.168.100.2' -SwisConnection $swis).gettype() | should be System.Management.Automation.PSCustomObject
    }
    It 'returns a URI member ' {
      (Get-OrionNode -IPAddress '192.168.100.2' -SwisConnection $swis).uri | should be 'swis://OrionVM./Orion/Orion.Nodes/NodeID=1'
    }
   
  }
  
  Context 'Running with -NodeID'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionNode -NodeID 1 -SwisConnection $swis} | Should Not Throw
    }
    It 'returns an  object ' {
      (Get-OrionNode -NodeID 1 -SwisConnection $swis).gettype() | should be System.Management.Automation.PSCustomObject
    }
    It 'returns a URI member ' {
      (Get-OrionNode -NodeID 1 -SwisConnection $swis).uri | should be 'swis://OrionVM./Orion/Orion.Nodes/NodeID=1'
    }
   
  }
  
  # scenario 1: call the function without arguments
  Context 'Running with -IPAddress -customproperties'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionNode -IPAddress '192.168.100.2' -customproperties -SwisConnection $swis} | Should Not Throw
    }
    It 'returns an  object ' {
      (Get-OrionNode -IPAddress '192.168.100.2' -customproperties -SwisConnection $swis).gettype() | should be System.Management.Automation.PSCustomObject
    }
    It 'returns a URI member ' {
      (Get-OrionNode -IPAddress '192.168.100.2' -customproperties -SwisConnection $swis).uri | should be 'swis://OrionVM./Orion/Orion.Nodes/NodeID=1/CustomProperties'
    }
   
  }
  
  Context 'Running with -NodeID -customproperties'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionNode -NodeID 1 -customproperties -SwisConnection $swis} | Should Not Throw
    }
    It 'returns an  object ' {
      (Get-OrionNode -NodeID 1 -customproperties -SwisConnection $swis).gettype() | should be System.Management.Automation.PSCustomObject
    }
    It 'returns a URI member ' {
      (Get-OrionNode -NodeID 1 -customproperties -SwisConnection $swis).uri | should be 'swis://OrionVM./Orion/Orion.Nodes/NodeID=1/CustomProperties'
    }
   
  }
  
}

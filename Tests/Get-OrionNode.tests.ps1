﻿# this is a Pester test file

#. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

#endregion


Import-Module -name $ModPath -Force 

InModuleScope PowerOrion{
  #describes the function Get-OrionNodeID
  Describe -Name 'Get-OrionNode'-Tags Readonly -Fixture  {

    # scenario 1: call the function without arguments
    Context 'Running with -IPAddress'   {
      # test 1: it does not throw an exception:
      It -name 'runs without errors' -test {
        # Gotcha: to use the "Should Not Throw" assertion,
        # make sure you place the command in a 
        # scriptblock (braces):
        { Get-OrionNode -IPAddress '192.168.100.2' -SwisConnection $swis} | Should Not Throw
      }
      It -name 'returns an  object ' -test {
        (Get-OrionNode -IPAddress '192.168.100.2' -SwisConnection $swis).gettype() | should be System.Management.Automation.PSCustomObject
      }
      It -name 'returns a URI member ' -test {
        (Get-OrionNode -IPAddress '192.168.100.2' -SwisConnection $swis).uri | should be 'swis://OrionVM./Orion/Orion.Nodes/NodeID=1'
      }
      It -name 'should throw when an invalid IP address is passed ' -test {
        {Get-OrionNode -IPAddress '260.168.100.2' -SwisConnection $swis} | Should Throw
      }
   
    }
  
    Context -Name 'Running with -NodeID'   -Fixture {
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
      It 'throws an error when an invalid IP is passed' {
        # Gotcha: to use the "Should Not Throw" assertion,
        # make sure you place the command in a 
        # scriptblock (braces):
        { Get-OrionNode -IPAddress '1920.168.100.2' -customproperties -SwisConnection $swis} | Should  Throw
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
}
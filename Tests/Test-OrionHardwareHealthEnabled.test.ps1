# this is a Pester test file

#. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

#endregion
#add-PSSnapin SwisSnapin 

Import-Module -name $ModPath -Force 

InModuleScope PowerOrion{
  #describes the function Get-OrionNodeID
  Describe -Name 'Test-OrionHardwareHealthEnabled' -Tags Readonly -Fixture {

    # scenario 1: call the function without arguments
    Context 'Running with -Swisconnection'   {
      # test 1: it does not throw an exception:
      It -name 'runs without errors' -test {
      
        { Test-OrionHardwareHealthEnabled  -SwisConnection $swis -NodeID 9999} | Should Not Throw
      }
      It -name 'returns an  object ' -test {
        (Test-OrionHardwareHealthEnabled  -SwisConnection $swis -NodeID 9999).gettype() | should be System.Object[]
      }
      It -name 'should not show hardwareenabled for a node that does not exist' -test {
        $results = Test-OrionHardwareHealthEnabled  -SwisConnection $swis -NodeID 9999
        $results.hardwareenabled | should be $false
      }
   
    }
  
  }
}
# this is a Pester test file

#. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

#endregion
InModuleScope PowerOrion{
#describes the function Get-OrionNodeID
Describe 'Get-OrionHostFromSwisConnection' {

  # scenario 1: call the function without arguments
  Context 'Runs with Swis connection'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionHostFromSwisConnection -SwisConnection $swis} | Should Not Throw
    }
    It 'returns a string' {
      (Get-OrionHostFromSwisConnection -SwisConnection $swis).gettype() | should be string
    }
    It 'matches the hostname in the Swis connections' {
      Get-OrionHostFromSwisConnection -SwisConnection $swis | should be $OrionServer
    }
   
  }
   
}
}
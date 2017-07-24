# this is a Pester test file

#. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

#endregion
#add-PSSnapin SwisSnapin 

Import-Module -name $ModPath -Force -Verbose

InModuleScope PowerOrion{
  #describes the function Get-OrionNodeID
  Describe -Name 'Get-OrionInstalledModules' -Fixture {

    # scenario 1: call the function without arguments
    Context 'Running with -Swisconnection'   {
      # test 1: it does not throw an exception:
      It -name 'runs without errors' -test {
      
        { Get-OrionInstalledModules  -SwisConnection $swis} | Should Not Throw
      }
      It -name 'returns an  object ' -test {
        (Get-OrionInstalledModules  -SwisConnection $swis).gettype() | should be System.Object[]
      }
      It -name 'returns a URI member ' -test {
        $modules = Get-OrionInstalledModules $swis
        $modules.licensename.Contains('SAM')| should be $true
      }
   
    }
  
  }
}
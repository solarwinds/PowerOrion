$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

#add-PSSnapin SwisSnapin
Import-Module -name $ModPath -Force -Verbose

InModuleScope PowerOrion{
  Describe "New-OrionNode" {
    Context 'Adding node with ICMP Only' {
            
      It "should not throw" {
        {New-OrionNode -SwisConnection $swis -ipaddress "192.168.100.1" -Verbose  } | should not throw
            
      }
           
    }
  }
}
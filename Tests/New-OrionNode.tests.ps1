$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

#add-PSSnapin SwisSnapin
Import-Module -name $ModPath -Force 

InModuleScope PowerOrion{
  Describe "New-OrionNode" -Tags Create, Node {
    Context 'Adding node with ICMP Only' {
    
               
      It "should not throw" {
        {New-OrionNode -SwisConnection $swis -ipaddress "192.168.100.1" -Verbose  } | should not throw
            
      }
      It "should throw when an invalid IP address is passed" {
        {New-OrionNode -SwisConnection $swis -ipaddress "260.168.100.1" -Verbose  } | should throw
            
      }
           
    }
  }
}
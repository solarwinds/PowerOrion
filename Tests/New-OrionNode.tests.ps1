$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

add-PSSnapin SwisSnapin

Describe "New-OrionNode" {
        Context 'Adding node with ICMP Only' {
            
            It "should not throw" {
              {New-OrionNode -SwisConnection $swis -ipaddress "127.0.0.1" -Verbose  } | should not throw
            
            }
           
        }
  }

$PSCommandPath
$CodeFile = $PSCommandPath
. (($CodeFile -replace '\\tests\\', '\public\')  -replace '\.tests\.ps1$', '.ps1')

add-PSSnapin SwisSnapin

Describe "New-OrionNode" {
        Context 'Adding poller with N.ResponseTime.ICMP.Native' {
            
        $nodeProps = @{
            "NodeID" = 1
        }

            It "should not throw" {
              {New-OrionPollerType -PollerType "N.ResponseTime.ICMP.Native" -NodeProperties $nodeProps -SwisConnection $Swis -Verbose  } | should not throw
            
            }
           
        }
  }

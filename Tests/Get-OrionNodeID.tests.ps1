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
Describe 'Get-OrionNodeID' {

  # scenario 1: call the function without arguments
  Context 'Running with -IPAddress'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionNodeID -IPAddress '192.168.100.2' -SwisConnection $swis} | Should Not Throw
    }
    It 'returns an  int ' {
      (Get-OrionNodeID -IPAddress '192.168.100.2' -SwisConnection $swis).gettype() | should be int
    }
    
   
  }
  
  # scenario 1: call the function without arguments
  Context 'Running with -NodeName'   {
    # test 1: it does not throw an exception:
    It 'runs without errors' {
      # Gotcha: to use the "Should Not Throw" assertion,
      # make sure you place the command in a 
      # scriptblock (braces):
      { Get-OrionNodeID -NodeName 'OrionVM' -SwisConnection $swis} | Should Not Throw
    }
    It 'returns an object' {
        (Get-OrionNodeID -NodeName 'OrionVM' -SwisConnection $swis).GetType() | should be int
    }
  }
  
}

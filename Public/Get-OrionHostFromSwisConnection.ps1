<#
    .Synopsis
    Extracts the name of the Orion server from a Swis connections
    .DESCRIPTION
   Private Helper functions to extract the host name from a Swis connection
    .EXAMPLE
    Example of how to use this cmdlet

#>
function Get-OrionHostFromSwisConnection
{
  [CmdletBinding()]
  [OutputType([string])]
  Param
  (
    # Swis Connection that from which to get the Orion Server Name
    [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true,
    Position=0)]
    [SolarWinds.InformationService.Contract2.InfoServiceProxy]
    $swisconnection    
  )

  Begin
  {
    Write-Verbose "Starting $($myinvocation.mycommand)"  
  }
  Process
  {
    try
    {
      $OrionHost = $swisconnection.ChannelFactory.Endpoint.Address.Uri.Host
    }
    catch 
    {
      Write-Error "Unable to Parse Host"
    }
        
  }
  End
  {
    Write-Verbose "Finishing $($myinvocation.mycommand)"
    Write-Output $OrionHost
  }
}
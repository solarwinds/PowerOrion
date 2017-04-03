#requires -Version 3.0

# initialize SWIS connection 
<#if (Get-PSSnapin -Name SwisSnapin -ErrorAction SilentlyContinue){
  remove-PSSnapin SwisSnapin
}

Add-PSSnapin SwisSnapin 
#>

#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

# Here I might...
    # Read in or create an initial config file and variable
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename

#Code to unload PSSNappin when Module is unloaded
$mInfo = $MyInvocation.MyCommand.ScriptBlock.Module
$mInfo.OnRemove = {
  write-verbose 'Unloading PowerOrion'
 if (Get-PSSnapin -Name SwisSnapin -ErrorAction SilentlyContinue){
  remove-PSSnapin SwisSnapin
}
}

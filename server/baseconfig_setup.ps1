configuration baseconfig_setup
{

    Import-Dscresource -ModuleName PowerShellModule

    node localhost
    {

        # Install xSystemSecurity module
        PSModuleResource xSystemSecurity
        {
            Module_name = "xSystemSecurity"
            Ensure = "Present"
        }
    }
}

baseconfig_setup -output "."
Start-DscConfiguration -Path .\baseconfig_setup -ComputerName localhost -Wait -Force -Verbose

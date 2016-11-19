configuration baseconfig_setup
{

    Import-Dscresource -ModuleName PowerShellModule

    node localhost
    {

        # Install xSystemSecurity module
        PSModuleResource xSystemSecurity
        {
            Module_name = 'xSystemSecurity'
            Ensure      = 'Present'
        }

        # Install GraniResource module
        PSModuleResource GraniResource
        {
            Module_name = 'GraniResource'
            Ensure      = 'Present'
        }
    }
}

GraniResource

baseconfig_setup -output '.'
Start-DscConfiguration -Path .\baseconfig_setup -ComputerName localhost -Wait -Force -Verbose

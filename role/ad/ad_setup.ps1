Set-StrictMode -Off

configuration ad_setup {
    Import-Dscresource -ModuleName PowerShellModule
    node localhost {
        PSModuleResource xDhcpServer{
            Module_name = "xActiveDirectory"
            Ensure = "Present"
        }
    }
}

ad_setup -output "."
Start-DscConfiguration -Path .\ad_setup -ComputerName localhost -Wait -Force -Verbose

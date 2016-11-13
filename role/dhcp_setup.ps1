Set-StrictMode -Off

configuration dhcp_setup {
    Import-Dscresource -ModuleName PowerShellModule
    node localhost {
        PSModuleResource xDhcpServer{
            Module_name = "xDhcpServer"
            Ensure = "Present"
        }
    }
}

dhcp_setup -output "."
Start-DscConfiguration -Path .\dhcp_setup -ComputerName localhost -Wait -Force -Verbose

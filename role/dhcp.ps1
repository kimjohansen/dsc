Set-StrictMode -Off

configuration dhcp {

    Import-Dscresource -ModuleName PowerShellModule

    node localhost {

        PSModuleResource xDhcpServer{
            Module_name = "xDhcpServer"
            Ensure = "Present"
        }

        WindowsFeature DHCP{
            Name = "DHCP"
            Ensure = "Present"
        }
    }
}

dhcp -output "."
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

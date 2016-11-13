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

        Import-Dscresource -ModuleName xDhcpServerScope
        Import-Dscresource -ModuleName xDhcpServerOption

        xDhcpServerScope Scope{
            DependsOn = '[WindowsFeature]DHCP'
            Ensure = 'Present'
            IPEndRange = '10.20.30.250'
            IPStartRange = '10.20.30.5'
            Name = 'PowerShellScope'
            SubnetMask = '255.255.255.0'
            LeaseDuration = '00:08:00'
            State = 'Active'
            AddressFamily = 'IPv4'
        }

        xDhcpServerOption Option{
            Ensure = 'Present'
            ScopeID = '10.20.30.0'
            DnsDomain = 'fox.test'
            DnsServerIPAddress = '10.20.30.1'
            AddressFamily = 'IPv4'
        }
    }
}

dhcp -output "."
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

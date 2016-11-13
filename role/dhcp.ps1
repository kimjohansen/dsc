Set-StrictMode -Off

configuration dhcp {

    Import-DscResource -module xDHCpServer

    node localhost {

        WindowsFeature DHCP{
            Name = "DHCP"
            Ensure = "Present"
            IncludeAllSubFeature = $true
        }

        WindowsFeature DHCPTools{
            DependsOn = '[WindowsFeature]DHCP'
            Ensure = "Present"
            Name = 'RSAT-DHCP'
            IncludeAllSubFeature = $true
        }

        xDhcpServerScope Scope{
            DependsOn = '[WindowsFeature]DHCP'
            Ensure = 'Present'
            IPEndRange = '10.20.30.250'
            IPStartRange = '10.20.30.5'
            Name = 'PowerShellScope'
            SubnetMask = '255.255.255.0'
            LeaseDuration = '08.00:00:00'
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

dhcp -output "." -ConfigurationData ConfigurationData.psd1
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

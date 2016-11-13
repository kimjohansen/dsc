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
            IPEndRange = $node.IPEndRange
            IPStartRange = $node.IPStartRange
            Name = $node.Name
            SubnetMask = $node.SubnetMask
            LeaseDuration = $node.LeaseDuration
            State = $node.State
            AddressFamily = $node.AddressFamily
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

dhcp -output "." -ConfigurationData .\ConfigurationData.psd1
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

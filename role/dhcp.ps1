Set-StrictMode -Off

configuration dhcp {
    node localhost {
        WindowsFeature DHCP{
            Name = "DHCP"
            Ensure = "Present"
        }
    }
}

dhcp -output "."
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

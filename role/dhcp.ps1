Set-StrictMode -Off

configuration dhcp {
    node localhost {
        WindowsFeature RoleDHCP{
            Name = "dhcp"
            Ensure = "Present"
        }
    }
}

dhcp -output "."
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

Set-StrictMode -Off

configuration Role-DHCP {
    node localhost {
    }
}

Role-DHCP -output "."
Start-DscConfiguration -Path .\Role-DHCP -ComputerName localhost -Wait -Force -Verbose

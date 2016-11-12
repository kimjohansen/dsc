Set-StrictMode -Off

configuration dhcp {
    node localhost {
    }
}

dhcp -output "."
Start-DscConfiguration -Path .\dhcp -ComputerName localhost -Wait -Force -Verbose

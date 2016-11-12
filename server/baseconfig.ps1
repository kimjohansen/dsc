Set-StrictMode -Off

configuration BaseConfig {
    node localhost {
        Registry DisableIPv6 {
            Force = "True"
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters"
            ValueName = "DisabledComponents"
            ValueData = "0x10111110"
            ValueType = "Dword"
            Hex = "True"
        }
    }
}

BaseConfig -output "."
Start-DscConfiguration -Path .\BaseConfig –ComputerName localhost -Wait -Force -Verbose

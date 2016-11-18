configuration BaseConfig 
{
    node localhost
    {
        # Disable autostart of ServerManager on login
        Registry ServerManager
        {
            Key         = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager'
            ValueName   = 'DoNotOpenServerManagerAtLogon'
            Force       =  True
            ValueData   = '1'
            ValueType   = 'Dword'
        }

#        Registry DisableIPv6 {
#            Force = "True"
#            Ensure = "Present"
#            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters"
#            ValueName = "DisabledComponents"
#            ValueData = "0x10111110"
#            ValueType = "Dword"
#            Hex = "True"
#        }
    }
}

BaseConfig -output "."
Start-DscConfiguration -Path .\BaseConfig -ComputerName localhost -Wait -Force -Verbose

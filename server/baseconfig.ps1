configuration BaseConfig 
{
    node localhost
    {

        # Disable autostart of ServerManager on login
        Registry ServerManager
        {
            Key         = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager'
            ValueName   = 'DoNotOpenServerManagerAtLogon'
            Force       =  $true
            ValueData   = '1'
            ValueType   = 'Dword'
        }

        ## Network Configuration
        #Disable IPv6
        Registry IPv6
        {
            Key         = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters'
            ValueName   = 'DisabledComponents'
            Force       = $true
            ValueData   = 'ff' 
            ValueType   = 'Dword'
        }
    }
}

BaseConfig -output "."
Start-DscConfiguration -Path .\BaseConfig -ComputerName localhost -Wait -Force

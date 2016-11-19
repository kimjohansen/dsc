configuration BaseConfig 
{

    # Importing required modules
    Import-DSCResource -Module MSFT_xSystemSecurity -Name xUac
    Import-DSCResource -Module MSFT_xSystemSecurity -Name xIEEsc

    node localhost
    {
        ## Cosmetic preferences

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

        # Disable IPv6 on nontunnel interfaces (except the loopback) and on IPv6 tunnel interface
        Registry IPv6
        {
            Key         = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters'
            ValueName   = 'DisabledComponents'
            Force       = $true
            ValueData   = '255' 
            ValueType   = 'Dword'
        }

        ## Security settings

        # Disable User Account Control
        xUAC UAC
        {
            Setting = "NeverNotifyAndDisableAll"
        }

        # Disable IE Enhanced Security Configuration for Administrator
        xIEEsc IEEsc
        {
            IsEnabled = $true
            UserRole = "Administrator"
        }
    }
}

BaseConfig -output "."
Start-DscConfiguration -Path .\BaseConfig -ComputerName localhost -Wait -Force

[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node localhost
    {
        Settings
        {
            ConfigurationMode = 'ApplyOnly'
        }
    }
}

LCMConfig -output '.'

Set-DscLocalConfigurationManager -Path .\LCMConfig -ComputerName localhost

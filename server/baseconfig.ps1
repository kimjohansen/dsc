configuration BaseConfig 
{

    # Importing required modules
    Import-DSCResource -Module xSystemSecurity -Name xUac
    Import-DSCResource -Module xSystemSecurity -Name xIEEsc
    Import-DscResource -ModuleName GraniResource

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
            Setting     = 'NeverNotifyAndDisableAll'
        }

        # Disable IE Enhanced Security Configuration for Administrator
        xIEEsc IEEsc
        {
            IsEnabled   = $false
            UserRole    = 'Administrators'
        }

        ## SSL

        #region Protcol Configuration

        # Disable Multi-Protocol Unified Hello
        Registry "DisableServerMultiProtocolUnifiedHello"
        {
            Key         = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\Multi-Protocol Unified Hello\Server'
            ValueName   = 'Enabled'
            ValueType   = 'Dword'
            Force       = $true
            ValueData   = '0'
        }

        # Disable PCT1.0
        Registry "DisableServerPCT10"
        {
            Key         = 'HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\PCT 1.0\Server'
            ValueName   = 'Enabled'
            ValueType   = 'Dword'
            Force       = $true
            ValueData   = '0'
        }

        # Disable SSL 3.0 / 2.0
        $sslVersion = 'SSL 3.0', 'SSL 2.0'
        foreach ($x in $sslVersion)
        {
            $name = $x.Replace('.', '').Replace(' ','')
            Registry "DisableServer$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$x\Server"
                ValueName   = 'Enabled'
                ValueType   = 'Dword'
                Force       = $true
                ValueData   = '0'
            }
        }

        # Add TLS 1.0 / 1.1 / 1.2
        $tlsVersion = 'TLS 1.0', 'TLS 1.1', 'TLS 1.2'
        foreach ($x in $tlsVersion)
        {
            $name = $x.Replace('.', '').Replace(' ','')
            Registry "EnableServer$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$x\Server"
                ValueName   = 'Enabled'
                ValueType   = 'Dword'
                Force       = $true
                Hex         = $true
                ValueData   = '0xffffffff'
            }

            Registry "EnableByDefaultServer$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$x\Server"
                ValueName   = 'DisabledByDefault'
                ValueType   = 'Dword'
                Force = $true
                ValueData   = '0'
            }

            Registry "EnableClient$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$x\Client"
                ValueName   = 'Enabled'
                ValueType   = 'Dword'
                Force       = $true
                Hex         = $true
                ValueData   = '0xffffffff'
            }

            Registry "EnableByDefaultClient$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$x\Client"
                ValueName   = 'DisabledByDefault'
                ValueType   = 'Dword'
                Force       = $true
                ValueData   = '0'
            }
        }

        #region Cipher Configuration

        # Disable insecure Ciphers
        $insecureCiphers = 'DES 56/56', 'NULL', 'RC2 128/128', 'RC2 40/128', 'RC2 56/128', 'RC4 40/128', 'RC4 56/128', 'RC4 64/128', 'RC4 128/128'
        foreach ($x in $insecureCiphers)
        {
            $name = $x.Replace(' ', '').Replace('/', '')

            cRegistryKey "KeyDisableCipher$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$x"
                Ensure      = 'Present'
            }

            Registry "DisableCipher$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$x"
                ValueName   = 'Enabled'
                ValueType   = 'Dword'
                Force       = $true
                ValueData   = '0'
            }        
        }

        # Enable secure Ciphers
        $secureCiphers =  'AES 128/128', 'AES 256/256', 'Triple DES 168/168'
        foreach ($x in $secureCiphers)
        {
            $name = $x.Replace(' ', '').Replace('/', '')

            cRegistryKey "KeyEnableCipher$name"
            {
                Key     = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$x"
                Ensure  = 'Present'
            }

            Registry "EnableCipher$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$x"
                ValueName   = 'Enabled'
                ValueType   = 'Dword'
                Force       = $true
                Hex         = $true
                ValueData   = '0xffffffff'
            }        
        }

        #region Hash Configuration

        # Disable MD5
        $hashMD5 = 'MD5'
        Registry "DisableHash$hashMD5"
        {
            Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\$hashMD5"
            ValueName   = 'Enabled'
            ValueType   = 'Dword'
            ValueData   = '0'
            Force       = $true
        }        

        # Enable SHA
        $hashSHA = 'SHA'
        Registry "DisableHash$hashSHA"
        {
            Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\$hashSHA"
            ValueName   = 'Enabled'
            ValueType   = 'Dword'
            Force       = $true
            Hex         = $true
            ValueData   = '0xffffffff'
        }        

        #region KeyExchangeAlgorithm Configuration

        # Enable Diffie-Hellman / PKCS
        $keyExchangeAlgorithm = 'Diffie-Hellman', 'PKCS'
        foreach ($x in $keyExchangeAlgorithm)
        {
            $name = $x.Replace('-', '')
            Registry "EnableKeyAlgorithm$name"
            {
                Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\$x"
                ValueName   = "Enabled"
                ValueType   = "Dword"
                Force       = $true
                Hex         = $true
                ValueData   = "0xffffffff"
            }
        }

        #region Cipher Suite Configuration (Enables Perfect Forward Secrecy)

        $cipherSuitesOrder = @(
            'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521',
            'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384',
            'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256',
            'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P521',
            'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P384',
            'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA_P256',
            'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P521',
            'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P521',
            'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P384',
            'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256',
            'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P384',
            'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA_P256',
            'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P521',
            'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384_P384',
            'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P521',
            'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P384',
            'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256_P256',
            'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P521',
            'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384_P384',
            'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P521',
            'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P384',
            'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA_P256',
            'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P521',
            'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P384',
            'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256_P256',
            'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P521',
            'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P384',
            'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA_P256',
            'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256',
            'TLS_DHE_DSS_WITH_AES_256_CBC_SHA',
            'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256',
            'TLS_DHE_DSS_WITH_AES_128_CBC_SHA',
            'TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'
        )
        $cipherSuitesAsString = [string]::join(',', $cipherSuitesOrder)
        Registry "EnableCipherSuiteOrder"
        {
            Key         = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
            ValueName   = 'Functions'
            ValueType   = 'String'
            Force       = $true
            ValueData   = $cipherSuitesAsString
        }
    }
}

BaseConfig -output "."
Start-DscConfiguration -Path .\BaseConfig -ComputerName localhost -Wait -Force -Verbose

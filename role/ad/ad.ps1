Set-StrictMode -Off

configuration ad {

    Import-DscResource -module xActiveDirectory
    node localhost {

        WindowsFeature ADDSInstall{
            Name = "AD-Domain-Services"
            Ensure = "present"
            IncludeAllSubFeature = $true
        }

#        WindowsFeature DHCPTools{
#            DependsOn = '[WindowsFeature]DHCP'
#            Ensure = "Present"
#            Name = 'RSAT-DHCP'
#            IncludeAllSubFeature = $true
#        }
    }
}

ad -output "." -ConfigurationData .\ConfigurationData.psd1
Start-DscConfiguration -Path .\ad -ComputerName localhost -Wait -Force -Verbose

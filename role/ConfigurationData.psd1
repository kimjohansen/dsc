@{
    AllNodes = @(
 
        @{
            NodeName           = "*"
            LeaseDuration      = "10.00:00:00"
            State              = "Active"
            AddressFamily      = 'IPv4'


       },
        @{
            NodeName           = "Localhost"
            Name               = "ClientNetwork"
            IPStartRange       = "10.20.30.100"
            IPEndRange         = "10.20.30.200"
            SubnetMask         = "255.255.255.0"

        }

    );
}

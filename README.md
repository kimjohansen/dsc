# dsc

## Prerequirements

* https://www.microsoft.com/en-us/download/details.aspx?id=50395
* Install-Module -Name PowerShellModule

## Usage

BaseConfig: 

iwr https://raw.githubusercontent.com/kimjohansen/dsc/master/server/baseconfig.ps1 -UseBasicParsing | iex

Role:

iwr https://raw.githubusercontent.com/kimjohansen/dsc/master/role/dhcp.ps1 -UseBasicParsing | iex


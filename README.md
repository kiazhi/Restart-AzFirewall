# Restart-AzFirewall

A simple PowerShell cmdlet module to reboot Azure Firewall (PaaS).

## Pre-requisite

1. PowerShell
2. Azure PowerShell Module

## How-To

1. Clone the repository

	```sh
	git clone https://github.com/kiazhi/Restart-AzFirewall.git
	```

2. Install and Import Azure PowerShell module

	```powershell
	# Install Azure PowerShell module if havn't done before
	Install-Module -Name Az

	# Import Azure PowerShell module if havn't done before
	Import-Module -Name Az
	```

3. Import the Restart-AzFirewall module

	```powershell
	# Change to the repository source code directory
	cd ./Restart-AzFirewall/src

	# Import the PowerShell script module
	Import-Module ./Restart-AzFirewall.psm1
	```

3. Use `Get-Help` to know the command

	```powershell
	# Use Get-Help to get help on the Restart-Firewall cmdlet

	Get-Help Restart-AzFirewall -Full
	```

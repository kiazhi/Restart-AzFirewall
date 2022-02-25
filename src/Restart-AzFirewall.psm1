<#
 .Synopsis
  Restarts an Azure Firewall.

 .Description
  Restarts an Azure Firewall. This function retains the existing Azure Firewall
  configurations prior to deallocating the resource to stop the Azure Firewall
  and reallocating the resource with those previously retained Azure Firewall
  configurations to start the Azure Firewall.

 .Parameter Name
  Specifies the name of the Azure Firewall that this cmdlet will restarts.

 .Parameter ResourceGroupName
  Specifies the name of a resource group to contain the Firewall.

 .Example
  # Restart the Azure Firewall.
  Restart-AzFirewall -Name "myAzureFirewall" -ResourceGroupName "myResourceGroup"

 .Example
  # Restart the Azure Firewall with Verbose outputs.
  Restart-AzFirewall -Name "myAzureFirewall" -ResourceGroupName "myResourceGroup" -Verbose

 .INPUTS
 	System.String

 .OUTPUTS
 	System.Object

 .NOTES
  Author: Ryen Tang
	GitHub: https://github.com/kiazhi
  
#>

function Restart-AzFirewall {

	[CmdletBinding()]

	param (
		[Parameter(Mandatory)]
		[String] $Name,

		[Parameter(Mandatory)]
		[String] $ResourceGroupName
	)

	begin {}

	process {

		$AzFirewall = Get-AzFirewall `
			-Name $Name `
			-ResourceGroupName $ResourceGroupName

		$ExistingPublicIpAddressName = (Get-AzResource -ResourceId (((Get-AzFirewall `
			-Name $Name `
			-ResourceGroupName $ResourceGroupName).IpConfigurations).PublicIpAddress).Id).Name

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose `
					-Message $("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - " `
						+ "Existing azFirewall Public Ip Address Name: $ExistingPublicIpAddressName")
		}

		$ExistingPublicIpAddressResourceGroupName = (Get-AzResource -ResourceId (((Get-AzFirewall `
			-Name $Name `
			-ResourceGroupName $ResourceGroupName).IpConfigurations).PublicIpAddress).Id).ResourceGroupName

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose `
					-Message $("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - " `
						+ "Existing azFirewall Public Ip Address Resource Group Name: $ExistingPublicIpAddressResourceGroupName")
		}

		$ExistingVirtualNetworkName = (Get-AzResource `
			-Name $(((Get-AzResource -ResourceId (((Get-AzFirewall `
				-Name $Name `
				-ResourceGroupName $ResourceGroupName).IpConfigurations).Subnet).Id)).ParentResource -replace '.*/','') `
			-ResourceType 'Microsoft.Network/virtualNetworks').Name

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose `
					-Message $("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - " `
						+ "Existing azFirewall Virtual Network Name: $ExistingVirtualNetworkName")
		}

		$ExistingVirtualNetworkResourceGroupName = (Get-AzResource `
			-Name $(((Get-AzResource -ResourceId (((Get-AzFirewall `
				-Name $Name `
				-ResourceGroupName $ResourceGroupName).IpConfigurations).Subnet).Id)).ParentResource -replace '.*/','') `
			-ResourceType 'Microsoft.Network/virtualNetworks').ResourceGroupName

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose `
					-Message $("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - " `
						+ "Existing azFirewall Virtual Network Resource Group Name: $ExistingVirtualNetworkResourceGroupName")
		}

		$AzFirewall.Deallocate()

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose -Message $("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - " `
					+ "Stopping azFirewall")
		}

		Set-AzFirewall `
			-AzureFirewall $AzFirewall

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose -Message $("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - " `
					+ "Stopped azFirewall")
		}

		$VirtualNetwork = Get-AzVirtualNetwork `
			-Name $ExistingVirtualNetworkName `
			-ResourceGroupName $ExistingVirtualNetworkResourceGroupName

		$PublicIpAddress = Get-AzPublicIpAddress `
			-Name $ExistingPublicIpAddressName `
			-ResourceGroupName $ExistingPublicIpAddressResourceGroupName

		$AzFirewall.Allocate($VirtualNetwork,$PublicIpAddress)

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose -Message "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - Starting azFirewall"
		}

		Set-AzFirewall -AzureFirewall $AzFirewall

		if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
				Write-Verbose -Message "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzzz') - Started azFirewall"
		}

	}

	end {}
	
}

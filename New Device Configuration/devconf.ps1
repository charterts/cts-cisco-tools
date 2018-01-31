param([string]$device)
function mainMenu {
	cls
	$firstInput = Read-Host 'Welcome to the CTS Network Device Configurator!

Please select from the following options:

1. Configure Cisco Switch
2. Configure SonicWALL Firewall
3. Exit

>'
	if ($firstInput -eq "1") {
		Write-Host 'You selected "Configure Cisco Switch"'
		New-CiscoSwitchConfig
	} elseif ($firstInput -eq "2") {
		Write-Host 'You selected "Configure SonicWALL Firewall"'
		Write-Host 'This section has not been built. Press enter to return to the main menu.'
		cmd /c pause | out-null
		mainMenu
	} elseif ($firstInput -eq "3") {
		Write-Host 'Exiting!'
		timeout 2 | out-null
		exit
	} else {
		Write-Host 'Please enter a valid number...'
	}
}
function Validate-Config {
	$validation = Read-Host "Is the information correct? Type Y or N"
	if ($validation -eq "Y") {
		return $true
	} elseif ($validation -eq "N") {
		return $false
	} else {
		Write-Host $validation "is not a valid response. Please enter Y or N"
		Validate-Config
	}
}
function Write-CiscoSwitchConfig {
	param($hostname,$vlan1IP,$vlan1Netmask,$defaultGateway,$ipDomain,$ipNameServers,$adminUser,$enablePass) 
	$adminUserName = $adminUser.GetNetworkCredential().username
	$adminPassword = $adminUser.GetNetworkCredential().password
	$enableSecret = $enablePass.GetNetworkCredential().password
	$switchContent = Get-Content DefaultSwitch.txt
	$switchContent = $switchContent.Replace("#hostName#",$hostname)
	$switchContent = $switchContent.Replace("#adminUserName#",$adminUserName)
	$switchContent = $switchContent.Replace("#adminPassword#",$adminPassword)
	$switchContent = $switchContent.Replace("#enableSecret#",$enableSecret)
	$switchContent = $switchContent.Replace("#vlan1IP#",$vlan1IP)
	$switchContent = $switchContent.Replace("#vlan1Netmask#",$vlan1Netmask)
	$switchContent = $switchContent.Replace("#defaultGateway#",$defaultGateway)
	$switchContent = $switchContent.Replace("#ipDomain#",$ipDomain)
	$switchContent = $switchContent.Replace("#ipDomainServers#",$ipNameServers)
	Set-Content SwitchOutput.txt $switchContent
	notepad SwitchOutput.txt
	Write-Host "Switch configuration saved as SwitchOutput.txt!
	Press Enter to return to continue..."
	cmd /c pause | out-null
}

function New-CiscoSwitchConfig {
	cls
	Write-Host 'Please enter the following settings:'
	$hostname = Read-Host "Hostname"
	$vlan1IP = Read-Host "VLAN1 IP Address"
	$vlan1Netmask = Read-Host "VLAN1 Subnet Mask"
	$defaultGateway = Read-Host "Default Gateway IP"
	$ipDomain = Read-Host "Domain"
	$ipNameServers = Read-Host "DNS Servers (separated by spaces)"
	Write-Host 'Press enter to input the cts admin username and password.'
	cmd /c pause | out-null
	$adminUser = Get-Credential -credential "cts"
	Write-Host 'Please enter to the enable password.'
	cmd /c pause | out-null
	$enablePass = Get-Credential -credential "enable"
	$validationCheck = Validate-Config
	if ($validationCheck -eq $true) {
		Write-CiscoSwitchConfig $hostname $vlan1IP $vlan1Netmask $defaultGateway $ipDomain $ipNameServers $adminUser $enablePass
		mainMenu
	} else {
		New-CiscoSwitchConfig
	}
}
mainMenu
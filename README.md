# cts-cisco-tools
A collection of homemade tools used by CTS Engineers to work with Cisco devices. 

# get-ciscoswitchinfo.ps1

Prerequisites: Requires PoSH-SSH Installed from the PowerShell Gallery. (https://www.powershellgallery.com/packages/Posh-SSH/2.0.1) 

Syntax: <code>.\get-ciscoswitchinfo.ps1 switchIPaddress</code><p>
  ex:<code> .\get-ciscoswitchinfo.ps1 192.168.0.2</code>
  
Outputs MAC, Model, System Serial Number and IP addresses that are associated to VLANs as strings.

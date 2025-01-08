# Define the path to the text file containing server hostnames
$filePath = "masterserverlist.txt"

# Read the hostnames from the text file
$servers = Get-Content $filePath | ForEach-Object {
    [PSCustomObject]@{
        Hostname = $_.Trim()
        Port     = 443
    }
}

# Function to check certificate expiration
function Get-CertificateExpiration {
    param (
        [string]$Hostname,
        [int]$Port
    )
    
    try {
        # Connect to the server
        $client = New-Object System.Net.Sockets.TcpClient($Hostname, $Port)
        $stream = $client.GetStream()
        $sslStream = New-Object System.Net.Security.SslStream($stream, $false)
        $sslStream.AuthenticateAsClient($Hostname)
        
        # Retrieve the certificate
        $certificate = $sslStream.RemoteCertificate
        $certificate2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certificate
        
        # Return the expiration date
        [PSCustomObject]@{
            Hostname       = $Hostname
            Port           = $Port
            ExpirationDate = $certificate2.NotAfter
            DaysRemaining  = ($certificate2.NotAfter - (Get-Date)).Days
        }
    } catch {
        Write-Error "Error checking $Hostname"
    } finally {
        # Clean up
        $sslStream.Close()
        $client.Close()
    }
}

# Loop through each server and check its certificate
$results = foreach ($server in $servers) {
    Get-CertificateExpiration -Hostname $server.Hostname -Port $server.Port
}

# Display the results
$results | Format-Table Hostname, Port, ExpirationDate, DaysRemaining -AutoSize
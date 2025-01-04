# Define paths to the different server text files
$files = @{
    "1" = "C:\path\to\servers1.txt"
    "2" = "C:\path\to\servers2.txt"
    "3" = "C:\path\to\servers3.txt"
    "4" = "C:\path\to\servers4.txt"
}

# Display a menu to choose the server file
Write-Host "Select a division to reboot:" -ForegroundColor Cyan
Write-Host "1. Atlanta"
Write-Host "2. Dallas"
Write-Host "3. Detroit"

# Prompt for user input
$choice = Read-Host "Enter the number corresponding to your choice"

# Validate the input and select the corresponding file
if ($files.ContainsKey($choice)) {
    $serversFile = $files[$choice]
} else {
    Write-Host "Invalid choice. Exiting." -ForegroundColor Red
    exit
}

# Check if the selected file exists
if (-Not (Test-Path $serversFile)) {
    Write-Host "The file does not exist at the specified path." -ForegroundColor Red
    exit
}

# Read server names from the selected file
$servers = Get-Content -Path $serversFile

# Loop through each server and attempt to reboot
foreach ($server in $servers) {
    Write-Host "Attempting to reboot server: $server" -ForegroundColor Yellow
    
    try {
        # Reboot the server using Restart-Computer
        Restart-Computer -ComputerName $server -Force -ErrorAction Stop
        
        Write-Host "Successfully rebooted server: $server" -ForegroundColor Green
    } catch {
        Write-Host "Failed to reboot server: $server" -ForegroundColor Red
    }
}

Write-Host "Reboot process completed." -ForegroundColor Cyan
Write-Host "Press any key to exit..." -ForegroundColor Cyan
Read-Host
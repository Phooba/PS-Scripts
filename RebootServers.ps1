# Define paths to the different server text files
$files = @{
    "1" = "C:\scripts\batch1.txt"
    "2" = "C:\scripts\batch2.txt"
    "3" = "C:\scripts\batch3.txt"
    "4" = "C:\scripts\batch4.txt"
    "5" = "C:\scripts\batch5.txt"
}

# Display a menu to choose the server file
Write-Host "Select a Server Batch to reboot:" -ForegroundColor Cyan
Write-Host "1. Eastern Time"
Write-Host "2. Central Time"
Write-Host "3. Mountain Time"
Write-Host "4. Pacific Time"
Write-Host "5. OCONUS"

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
        Restart-Computer -ComputerName $server -Force -ErrorAction Stop
        
        Write-Host "Successfully rebooted server: $server" -ForegroundColor Green
    } catch {
        Write-Host "Failed to reboot server: $server" -ForegroundColor Red
    }
}

Write-Host "Reboot process completed." -ForegroundColor Cyan
Write-Host "Press any key to exit..." -ForegroundColor Cyan
Read-Host
$files = @{
    "1" = "C:\scripts\batch1.txt"
    "2" = "C:\scripts\batch2.txt"
    "3" = "C:\scripts\batch3.txt"
    "4" = "C:\scripts\batch4.txt"
    "5" = "C:\scripts\batch5.txt"
    "6" = "C:\scripts\all_servers.txt"
}

$timeout = 30

while ($true) {
    Write-Host "Select a Server Batch to reboot:" -ForegroundColor Cyan
    Write-Host "1. Eastern Time"
    Write-Host "2. Central Time"
    Write-Host "3. Mountain Time"
    Write-Host "4. Pacific Time"
    Write-Host "5. OCONUS"
    Write-Host "6. All Servers"
    Write-Host "7. Exit"

    $choice = Read-Host "Enter the number corresponding to your choice"

    # Exit option
    if ($choice -eq "7") {
        Write-Host "Exiting script..." -ForegroundColor Cyan
        break
    }

    # Validate the input and select the corresponding file
    if ($files.ContainsKey($choice)) {
        $serversFile = $files[$choice]
    } else {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        break
    }

    # Check if the selected file exists
    if (-Not (Test-Path $serversFile)) {
        Write-Host "The file does not exist at the specified path." -ForegroundColor Red
        break
    }

    $servers = Get-Content -Path $serversFile

    # Loop through each server and attempt to reboot
    foreach ($server in $servers) {
        Write-Host "Attempting to reboot server: $server" -ForegroundColor Yellow
        
        try {
            $job = Start-Job -ScriptBlock {
                param ($server)
                Restart-Computer -ComputerName $server -Force -ErrorAction Stop
            } -ArgumentList $server

            if (Wait-Job -Job $job -Timeout $timeout) {
                Write-Host "Successfully rebooted server: $server" -ForegroundColor Green
            } else {
                Write-Warning "Timeout reached for server: $server! The reboot may not have completed."
                Stop-Job -Job $job
            }

            Remove-Job -Job $job
        } catch {
            Write-Host "Failed to reboot server: $server" -ForegroundColor Red
        }
    }

    Write-Host "Reboot process completed." -ForegroundColor Cyan
    Write-Host "Returning to menu..." -ForegroundColor Cyan
}
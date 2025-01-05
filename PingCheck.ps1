# Read server names from the selected file
$servers = Get-Content "servers.txt"

foreach ($hostname in $servers){
    if (Test-Connection -ComputerName $hostname -Count 1 -ErrorAction SilentlyContinue){
        Write-Host "$hostname is up" -ForegroundColor Green
    }
    else {Write-Host "$hostname is down"
    }
}

Read-Host -Prompt "Press any key to continue..." -ForegroundColor Cyan
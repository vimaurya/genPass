$status = Get-Content -Path ".\status.txt"

if ($status -eq "DatabaseExists=True") {
	Write-Host ""
} elseif ($status -eq "DatabaseExists=False") {
	Write-Host "Database does not exist"
	& .\database.ps1 
}

for($i=0;$i -lt 20; $i++){Write-Host""}

& .\billing.ps1

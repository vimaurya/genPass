$status = Get-Content -Path ".\status.txt"

if ($status -eq "DatabaseExists=True") {
    	Write-Host "Database already exists"
} elseif ($status -eq "DatabaseExists=False") {
	Write-Host "Database does not exist"
	& .\database.ps1 
}

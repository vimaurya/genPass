# Load the MySQL Connector assembly
[Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll")

$statusLines = Get-Content -Path ".\status.txt"
$connectionString = $statusLines[2]

function drop-database{
	param(
		[string]$database
	)

    	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    	$connection.ConnectionString = $connectionString

    	try {
        	$connection.Open()

        	$command = $connection.CreateCommand()
        	$query = "DROP DATABASE $database"
       		$command.CommandText = $query
		
		$command.ExecuteNonQuery()
		
		Write-Host "Database '$database' dropped"
	
		$statusLines[0] = "DatabaseExists=False"
		$statusLines | Set-Content -Path ".\status.txt"

	} catch {
		Write-Host "Error : $_"
	} finally {
		$connection.Close()
	}
}


drop-database 'bsRecords'
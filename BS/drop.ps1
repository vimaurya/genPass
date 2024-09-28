$statusLines = Get-Content -Path ".\status.txt"

function drop-database{
	param(
		[string]$database
	)
	$connectionString = "server=localhost;port=3306;user id=root;password=vikash;"

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
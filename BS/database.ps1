<#
Database

product_id	|	name	|	price
    ^			 ^		 ^
    |			 |		 |
   int			 |		 |	
Primary key	      varchar(50)      float

#>

# Load the MySQL Connector assembly
[Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll")

$statusLines = Get-Content -Path ".\status.txt"

function database-status {
    param(
	[string]$database
    )
    
    $connectionString = "server=localhost;port=3306;user id=root;password=vikash;"

    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    $connection.ConnectionString = $connectionString

    try {
        $connection.Open()

        $command = $connection.CreateCommand()

        $query = "SELECT schema_name AS name FROM information_schema.schemata WHERE SCHEMA_NAME = '$database';"

        $command.CommandText = $query

	$result = $command.ExecuteScalar()
	
	if($result){
		Write-Host "Database '$database' exists"
		return $true
	} else {	
		Write-Host "Database '$database' does not exist"
		return $false
	}
    } catch {
        Write-Host "Error: $_"
    } finally {
        $connection.Close()
    }
}

function database-create{
    param(
        [string]$database
    )

    $connectionString = "server=localhost;port=3306;user id=root;password=vikash;"

    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    $connection.ConnectionString = $connectionString

    try {
        $connection.Open()

        $command = $connection.CreateCommand()

        $query = "CREATE DATABASE $database"

        $command.CommandText = $query

	$command.ExecuteNonQuery()
	
	Write-Host "Database '$database' created"
	
	$statusLines[0] = "DatabaseExists=True"
	$statusLines | Set-Content -Path ".\status.txt"

	$query = "USE $database;

		 CREATE TABLE products(
			product_id INT PRIMARY KEY, 
			product_name VARCHAR(50),
			price DECIMAL(18,2)
		 );"

	$command.CommandText = $query
	$command.ExecuteNonQuery()

	Write-Host "Table created"

    } catch {
        Write-Host "Error in creation: $_"
    } finally {
        $connection.Close()
    }
}

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

function main{
	try{
		$databaseName = ($statusLines[1] -split "=")[1]
	
		$res = database-status $databaseName

		if($res){
			Write-Host "Aborting database creation | Already exists"
			return
		} else{
			database-create $databaseName	
			Write-Host "I am here"
		}
	} catch{
		Write-Host "Error : $_"
	}
}

main

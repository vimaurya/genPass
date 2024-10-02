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
$connectionString = $statusLines[2]

function database-status {
    param(
	[string]$database
    )

    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    $connection.ConnectionString = $connectionString

    try {
        $connection.Open()

        $command = $connection.CreateCommand()

        $query = "SELECT schema_name AS name FROM information_schema.schemata WHERE SCHEMA_NAME = '$database';"

        $command.CommandText = $query

	$result = $command.ExecuteScalar()
	
	return $result

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
			product_name VARCHAR(50) NOT NULL,
			price DECIMAL(18,2) NOT NULL
		 );"

	$command.CommandText = $query
	$command.ExecuteNonQuery()

	Write-Host "Table products created"

	$query = "CREATE TABLE transactions(
			transaction_id VARCHAR(50) PRIMARY KEY,
			time_stamp DATETIME NOT NULL,
			amount DECIMAL(10, 2) NOT NULL
		 );"
	$command.CommandText = $query
	$command.ExecuteNonQuery()

	Write-Host "Table transcations created"

    } catch {
        Write-Host "Error in creation: $_"
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
			$statusLines[0] = "DatabaseExists=True"
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

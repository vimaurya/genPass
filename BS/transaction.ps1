# Load the MySQL Connector assembly
[Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll")

$statusLines = Get-Content -Path ".\status.txt"
$database = ($statusLines -split "=")[1]
$connectionString = $statusLines[2]

function Get-price([string]$unique_id) {
	
	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.ConnectionString = $connectionString

	try{
		$statusLines = Get-Content -path ".\status.txt"
		$database = ($statusLines[1] -split "=")[1]

		$connection.Open()
		$command = $connection.CreateCommand()
		$query = "use $database; SELECT product_name, price FROM products WHERE unique_id='$unique_id';"
		
		$command.CommandText = $query
		$adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
		$data = New-Object System.Data.DataTable
		$adapter.Fill($data)
		if($data.Rows.Count -gt 0){
			$price = [float]$data.Rows[0]["price"]
			$product = $data.Rows[0]["product_name"]
			Write-Host "product : $product, price : $price"
			return @{
				name = $product
				price = $price
			}
		} else { return }

	} catch{
		Write-Host "Error : $_"
	} finally {
		$connection.Close()
	}
}

function Get-Tid{
	param(
		[string]$prefix = "TXN"
	)

	$transaction_time = Get-Date

	$timestamp = $transaction_time.ToString("yyyyMMddHHmmssfff")

	$unique = Get-Random -Minimum 9999 -Maximum 100000

	$Tid = "$prefix-$timestamp-$unique"

	return $Tid, $transaction_time
}

function write-transaction([float]$amount){
	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.connectionString = $connectionString

	$Tid, $transaction_time = Get-Tid

	try{
		$connection.Open()
		$command = $connection.CreateCommand()
 		$query = "INSERT INTO transactions (transaction_id, time_stamp, amount) VALUES (@Tid, @TransactionTime, @Amount);"

		$command.CommandText = $query		

	        $null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Tid", $Tid)))
        	$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@TransactionTime", $transaction_time.ToString("yyyy-MM-dd HH:mm:ss"))))
       		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Amount", $amount)))

		$command.ExecuteNonQuery() 
		Write-Host "Transaction complete"
	} catch {
		Write-Host "Error : $_"
	} finally {
		$connection.Close()
	}
}
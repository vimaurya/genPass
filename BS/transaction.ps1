function Get-price([int]$prd_id) {

	$connectionString = "server=localhost;port=3306;user id=root;password=vikash;"
	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.ConnectionString = $connectionString

	try{
		$statusLines = Get-Content -path ".\status.txt"
		$database = ($statusLines[1] -split "=")[1]

		$connection.Open()
		$command = $connection.CreateCommand()
		$query = "use $database; SELECT price FROM products WHERE product_id=$prd_id;"
		$command.CommandText = $query
		
		$price = $command.ExecuteScalar()
		
		if($price){
			Write-Host "prd_id : $prd_id, price : $price"
			return $price
		} else {
			Write-Host "can't retrive price"
			return
		}
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

function write-transaction($amount){
	
}
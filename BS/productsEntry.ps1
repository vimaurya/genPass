# Load the MySQL Connector assembly
[Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll")

$statusLines = Get-Content -path "./status.txt"

$database = ($statusLines[1] -split "=")[1]
$connectionString = $statusLines[2]

function generatebarcode([string]$brc_id){
	Start-Process -FilePath "python" -ArgumentList "./generateBarcode.py", "--code",  "$brc_id"
}

function stopAndStart{
#	Start-Process -FilePath "powershell" -ArgumentList "./productsEntry.ps1" -Wait
#	exit 1
	Clear-Host
	& .\productsEntry.ps1
	exit 1
}

function validate {
	param(
        	[Parameter(Mandatory = $true)]
        	$identifier,
        	$marker
    	)
    if ($identifier -eq 'b') {
		stopAndStart
	}
	$valid_vals = @(1, 2)

	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.connectionString = $connectionString
	
	try{
		$connection.Open()
		$command = $connection.CreateCommand()

	    if ($marker -eq 0) {

        	while ($identifier -notmatch '^\d+$' -or (-not ($valid_vals -contains $identifier))) {
					if ($identifier -eq 'b') {
						stopAndStart
						break
					}
            		Write-Host "Invalid"
            		$identifier = Read-Host "Enter your choice "
        	}

   		} elseif($marker -eq 1) {
        		while ($identifier -match '^\d+$') {
					if ($identifier -eq 'b') {
						stopAndStart
						break
					}
					Write-Host "Invalid"
					$identifier = Read-Host "Enter manufacturer "
        		}
			
				$query = "use $database; select manufacturer_id from manufacturer where manufacturer=@id;"
				
				$command.CommandText = $query
				$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@id", $identifier)))
				$id = $command.ExecuteScalar()

				if($id){return $id}	
				else {
					$choice = Read-Host "new manufacturer, want to add to database(Y/N) "
					if($choice -eq 'Y') {
						$manufacturer_id = Read-Host "Enter manufacturer_id "
						$query = "use $database; insert into manufacturer values(@manufacturer, @manufacturer_id);"
						
						$command.CommandText = $query

						$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@manufacturer", $identifier)))	

						$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@manufacturer_id", $manufacturer_id)))	
						$command.ExecuteNonQuery()
						
						Write-Host "manufacturer added"					
					}
				}
				
	    	} elseif($marker -eq 2) {
				while ($identifier -notmatch '^[\d\.]+$') {
					if ($identifier -eq 'b') {
						stopAndStart
						break
					}
					$identifier = Read-Host "Invalid. Enter again "
				} 
			} elseif($marker -eq 3) {
				while(($identifier -eq "") -or ($identifier -match '^\d+$')){
					$identifier = (Read-Host "Enter product_type ")
				}
				if ($identifier -eq 'b') {
					stopAndStart
				}
				$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
				$connection.connectionString = $connectionString

				try{
					
					$connection.Open()
					$command = $connection.CreateCommand()
					$query = "use $database; SELECT product_type FROM product_type WHERE product='$identifier';"

					$command.CommandText = $query
					$adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
					$data = New-Object System.Data.DataTable
					$adapter.Fill($data)

					if($data.Rows.Count -gt 0){
						$product_type = $data.Rows[0].product_type
						Write-Host "product : $identifier, product_type : $product_type"
						return @{
							flag = $true
							type = $product_type
						}
					}
					else{
						Write-Host "This product does not exist in the databse"
						return @{
							flag = $false
							type = $null
						}
					}
				} catch{
					Write-Host "Error : $_"
				} finally {
					$connection.Close()
				}
			} elseif($marker -eq 4){
				while($identifier -notmatch '^\d+$') {
					if ($identifier -eq 'b') {
						stopAndStart
						break
					}
					Write-Host "Invalid"
					$identifier = Read-Host "Enter unique_id "
				}
			} elseif($marker -eq 5){
				while(($identifier -eq "") -or ($identifier -match '^\d+$')){
					$identifier = (Read-Host "Enter product_name ")
				}
				if ($identifier -eq 'b') {
					stopAndStart
					break
				}
				$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
				$connection.connectionString = $connectionString

				try{
					$connection.Open()
					$command = $connection.CreateCommand()
					$query = "USE $database; SELECT unique_id FROM product_unique_id WHERE product_name=@name"
					
					$command.CommandText = $query

					$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@name", $identifier)))	
					$adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)
					$data = New-Object System.Data.DataTable
					$adapter.Fill($data)

					if($data.Rows.Count -gt 0){
						$unique_id = $data.Rows[0].unique_id

						return @{
							flag = $true
							unique_id = $unique_id
						}
					} else{
						return @{
							flag = $false
							unique_id = $null
						}
					}
				} catch{
					Write-Host "Error : $_"
				} finally{
					$connection.Close()
				}
			}

	} catch{
		Write-Host "Error : $_"	
	} finally {
		$connection.Close()
	}
	
    return $identifier
}


function entry{
	param(
		[Parameter(Mandatory=$true)]
		$product_name,
		$price,
		$product_type,
		$manufacturer_id,
		$barcode_id,
		$unique_id
	)
		
	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.connectionString = $connectionString
		
	try{
		$connection.Open()
		$command = $connection.CreateCommand()
		$query = "INSERT INTO products (product_name, price, product_type, manufacturer_id, barcode_id, unique_id) VALUES (@product_name, @price, @product_type, @manufacturer_id, @barcode_id, @unique_id);"

		$command.CommandText = $query
		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@product_name", $product_name)))
		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@price", $price)))
		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@product_type", $product_type)))
		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@manufacturer_id", $manufacturer_id)))
		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@barcode_id", $barcode_id)))
		$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@unique_id", $unique_id)))

		$command.ExecuteNonQuery()
		Write-Host "Product saved"	
	} catch{
		Write-Host "Error : $_"	
	} finally{
		$connection.Close()
	}	
}

function generate_barcodeId([string]$product_type,[string]$manufacturer_id,$unique_id){
	return "$product_type$manufacturer_id$unique_id"
}

function productsEntrymain{
	while($true) {

		for($i=0;$i -lt 35; $i++){Write-Host""}	
		Write-Host "----------------------"
		Write-Host "| Select an option : |"
		Write-Host "| 1.) Insert	     |"
		Write-Host "| 2.) Exit	     |"
		Write-Host "----------------------"
		$choice = validate (Read-Host "Enter your choice ") 0

		while($choice -eq 1){
			$product = (Read-Host "Enter product_type ")
			$type = validate $product 3	
			while(-not $type.flag){
				$product = (Read-Host "Enter product_type ")
				$type = validate $product 3	
			}
			$product_type = $type.type


			$product_name = Read-Host "Enter product_name "
			if($product_name -eq 'b') {break}
			$res = validate $product_name 5
			$price = $null
			$unique_id = $null

			if($res.flag){
				$unique_id = $res.unique_id
			} else {
				$unique_id = Read-Host "Enter unique_id "
				$unique_id = validate $unique_id 4
			}
			$price = (Read-Host "Enter price ")
			$price = validate $price 2
	
			$manufacturer = (Read-Host "Enter manufacturer ")
			$manufacturer_id = validate $manufacturer 1
			Write-Host "manufacturer : $manufacturer, id : $manufacturer_id"

			$barcode_id = generate_barcodeId $product_type $manufacturer_id $unique_id

			entry $product_name $price $product_type $manufacturer_id $barcode_id $unique_id
			generatebarcode $barcode_id
			Write-Host "Barcode generated for this product"
		}
		
		if($choice -eq 2){
			Write-Host "Terminating.."
			for($i=0;$i -lt 3; $i++){
				Start-Sleep -Milliseconds 873
				Write-Host "^"
			}
			Clear-Host
			break
		}
	}
}

productsEntrymain

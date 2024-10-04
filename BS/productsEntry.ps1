$statusLines = Get-Content -path "./status.txt"

$database = ($statusLines[1] -split "=")[1]
$connectionString = $statusLines[2]



function generate-barcode([string]$brc_id){
	Start-Process -FilePath "python" -ArgumentList "./generateBarcode.py", "--code",  "$brc_id"
}


function validate {
	param(
        	[Parameter(Mandatory = $true)]
        	$identifier,
        	$marker
    	)
    	$valid_vals = @(1, 2)

	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.connectionString = $connectionString
	
	try{
		$connection.Open()
		$command = $connection.CreateCommand()

	    	if ($marker -eq 0) {

        		while ($identifier -notmatch '^\d+$' -or (-not ($valid_vals -contains $identifier))) {
            			Write-Host "Invalid"
            			$identifier = Read-Host "Enter your choice "
        		}

   		} elseif($marker -eq 1) {

        		while ($identifier -match '^\d+$') {
				Write-Host "Invalid"
				$identifier = Read-Host "Enter manufacturer "
        		}
			
			$query = "use $database; select manufacturer_id from manufacturer where manufacturer=@id;"
			
			$command.CommandText = $query
			$null = $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@id", $identifier)))
			$id = $command.ExecuteScalar()

			if($id){return}	
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
				$identifier = Read-Host "Invalid. Enter again "
			}	
		}
	} catch{
		Write-Host "Error : $_"	
	} finally {
		$connection.Close()
	}
	
    return $identifier
}


function entry([string]$query){
		
	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.connectionString = $connectionString
		
	try{
		$connection.Open()
		$command = $connection.CreateComamnd()
		$command.CommandText = $query
		$command.ExecuteNonQuery()
	} catch{
		Write-Host "Error : $_"	
	} finally{
		$connection.Close()
	}	
}

function productsEntry-main{
	while($true) {

		for($i=0;$i -lt 35; $i++){Write-Host""}	
		Write-Host "----------------------"
		Write-Host "| Select an option : |"
		Write-Host "| 1.) Insert	     |"
		Write-Host "| 2.) Exit	     |"
		Write-Host "----------------------"
		$choice = validate (Read-Host "Enter your choice ") 0

		while($choice -eq 1){
			$product_type = (Read-Host "Enter product_type ")
			if ($product_type -eq 'b'){break}
			$product_type = validate $product_type 3
			$product_name = Read-Host "Enter product_name "
			if($product_name -eq 'b') {break}
			$price = (Read-Host "Enter price ")
			if($price -eq 'b') {break}
			$price = validate $price 2
			$manufacturer = (Read-Host "Enter manufacturer ")
			if($manufacturer -eq 'b'){break}
			$manufacturer_id = validate $manufacturer 1
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

productsEntry-main

<#
ToDos : 
1. Implement options to ask whether the user wants to enter manually or scan
2. Implement manual-billing function
3. implement a separate file for database creation
#> 

Write-Host "----------------------"
Write-Host "| Select an option : |"
Write-Host "| 1.) Manual	     |"
Write-Host "| 2.) Code scan	     |"
Write-Host "----------------------"

function validate {
    param(
        [Parameter(Mandatory = $true)]
        $InputNumber,
        $marker
    )

    if ($marker -eq 0) {
        while ($InputNumber -notmatch '^\d+$' -or ($InputNumber -ne 2 -and $InputNumber -ne 1)) {
            Write-Host "Invalid choice"
            $InputNumber = Read-Host "Enter your choice "
        }
    } else {
        while ($InputNumber -notmatch '^\d+$') {
            Write-Host "Invalid id"
            $InputNumber = Read-Host "Enter prid "
        }
    }

    return $InputNumber
}

function manual-billing{
	param(
		$prd_id
	)
	Write-Host "Inside manual-billing"
}

function database-status {
    param(
        [string]$query
    )

    $connectionString = "server=localhost;port=3306;user id=root;password=vikash;"

    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    $connection.ConnectionString = $connectionString

    try {
        $connection.Open()

        $command = $connection.CreateCommand()

        $query = "SELECT schema_name AS name FROM information_schema.schemata;"

        $command.CommandText = $query

        $adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter $command

        $dataSet = New-Object System.Data.DataSet
        $adapter.Fill($dataSet)

        $dataSet.Tables[0] | Format-Table

        return $dataSet.Tables[0]
    } catch {
        Write-Host "Error: $_"
    } finally {
        $connection.Close()
    }
}

function main{

	$choice = validate (Read-Host "Enter your choice ") 0

	if ($choice -eq 1){
		$prd_id = validate (Read-Host "Enter prid ") 1
		manual-billing $pr_id
	}
}

main
#database-status

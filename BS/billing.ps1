<#
ToDos : 
2. Implement write-transaction
3. Implement the scan method
#> 

."./transaction.ps1"

function validate {
    param(
        [Parameter(Mandatory = $true)]
        $InputNumber,
        $marker
    )
    $valid_vals = @(1, 2, 3)

    if ($marker -eq 0) {
        while ($InputNumber -notmatch '^\d+$' -or (-not ($valid_vals -contains $InputNumber))) {
            Write-Host "Invalid choice"
            $InputNumber = Read-Host "Enter your choice "
        }
    } else {
        while ($InputNumber -notmatch '^\d+$') {
            $InputNumber = Read-Host "Enter prid "
        }
    }

    return $InputNumber
}


function manual-billing{
	param(
		$prd_id
	)
	$price = Get-price $prd_id
	
	$Tid, $transaction_time = Get-Tid
	return $price
}

function main{
	while($true){
			
		Write-Host "----------------------"
		Write-Host "| Select an option : |"
		Write-Host "| 1.) Manual	     |"
		Write-Host "| 2.) Code scan	     |"
		Write-Host "| 3.) Exit 	     |"
		Write-Host "----------------------"

		$choice = validate (Read-Host "Enter your choice ") 0
		$amount = 0
		
		while($choice){
			$prd_id = Read-Host "Enter prid " 
			if($prd_id -eq 'q'){
				if($amount -ne 0){
					Write-Host "(Total amount) : $amount"
					write-transaction $amount
				}				
				$amount = 0
			}
			$prd_id = validate $prd_id 1
			$amount += manual-billing $prd_id	
		}
	}
}

main
<#
ToDos : 
1. Implement barcode generator
2. Implement barcode scanner
3. Implement the scan method
#> 

. "./transaction.ps1"

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
		return
        }
    }

    return $InputNumber
}


function manual-billing{
	param(
		$prd_id
	)
	$res = Get-price $prd_id
	
	return [float]$res.price
}

function main{
	while($true){
		for($i=0;$i -lt 30; $i++){Write-Host""}	
		Write-Host "----------------------"
		Write-Host "| Select an option : |"
		Write-Host "| 1.) Manual	     |"
		Write-Host "| 2.) Code scan	     |"
		Write-Host "| 3.) Exit 	     |"
		Write-Host "----------------------"

		$choice = validate (Read-Host "Enter your choice ") 0
		$amount = 0
		
		while($choice -eq 1){
			$prd_id = Read-Host "Enter prid " 
			if($prd_id -eq 'q'){
				if($amount -ne 0){
					Write-Host "(Total amount) : $amount"
					Start-Sleep -Seconds 4
					$paid = Read-Host "Y/N"
					if ($paid -eq "Y"){
						write-transaction $amount
						for($i=0;$i -lt 40; $i++){Write-Host""}
					}	
				}				
				$amount = 0
			} 
			if($prd_id -eq 'b'){
				for($i=0;$i -lt 5; $i++){Write-Host""}	
				break
			}
			else {
				$prd_id = validate $prd_id 1
				$amount += manual-billing $prd_id
			}	
		}

		if ($choice -eq 3) {
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

main
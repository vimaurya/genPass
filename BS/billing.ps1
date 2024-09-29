
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

function manual-billing{
	param(
		$prd_id
	)
	Write-Host "Inside manual-billing"
	$Tid, $transaction_time = Get-Tid
	Write-Host $Tid $transaction_time
}

function main{

	$choice = validate (Read-Host "Enter your choice ") 0

	if ($choice -eq 1){
		$prd_id = validate (Read-Host "Enter prid ") 1
		manual-billing $pr_id
	}
}

main
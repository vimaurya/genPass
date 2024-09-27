
<#
ToDos : 
1. Implement options to ask whether the user wants to enter manually or scan

#> 

Write-Host "----------------------"
Write-Host "| Select an option : |"
Write-Host "| 1.) Manual	     |"
Write-Host "| 2.) Code scan	     |"
Write-Host "----------------------"


function validate-choice{
	param(
		[Parameter(Mandatory = $true)]
        	$InputNumber
	)
	
	while ($InputNumber -notmatch '^\d+$' -or ($InputNumber -gt 2 -or $InputNumber -lt 1)){
		Write-Host "Invalid choice"
		$InputNumber = Read-Host "Enter your choice"
	}
	
	return $InputNumber
}

function manual-billing{
	param(
		
	)
}

$choice = validate-choice(Read-Host "Enter your choice");


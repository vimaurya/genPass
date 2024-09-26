
<#
ToDos : 
1. Implement options to ask whether the user wants to enter manually or scan

#> 

Write-Host "----------------------"
Write-Host "| Select an option : |"
Write-Host "| 1.) Manual	     |"
Write-Host "| 2.) Code scan	     |"
Write-Host "----------------------"


function validate{
	param(
		 [Parameter(Mandatory = $true)]
        	[ValidateScript({ $_ -match '^\d+$' })] 
        	$InputNumber
	)

	return $InputNumber
}

$choice = validate Read-Host "Enter your choice");

Write-host "This is choice $choice";

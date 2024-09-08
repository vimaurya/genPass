param(
	[string]$u,
	[string]$d
)

function Generate-Password{	
	param(
		$username,
	 	$domain
	)

	if (-not $username -or -not $domain){
		for ($i=0; $i -lt 3; $i++){
			Start-Sleep -Milliseconds 873
			Write-Host "^"
		}
			
		Write-Host "can not generate"
		return
	}

	$chars = 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 	'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
	
	$charDict = @{
		'a' = 0
		'b' = 1
		'c' = 2
		'd' = 3
		'e' = 4
		'f' = 5
		'g' = 6
		'h' = 7
		'i' = 8
		'j' = 9
		'k' = 10
		'l' = 11
		'm' = 12
		'n' = 13
		'o' = 14
		'p' = 15
		'q' = 16
		'r' = 17
		's' = 18
		't' = 19
		'u' = 20
		'v' = 21
		'w' = 22
		'x' = 23
		'y' = 24
		'z' = 25
	}

	$schars = '!', '@', '#', '_'	
	
	$specialChar = $schars[$domain.Length % 4]
	
	$passBuilder = New-Object -TypeName System.Text.StringBuilder
	

	$passBuilder.append($username[0].ToString().ToUpper())

	$websc = $domain
	
	
	foreach ($char in $domain.ToCharArray()){
		$chr = $char.ToString()	
		$key = [int]($charDict[$chr])
		if ($key -ne $null){
			$key += 2
			$websc = $websc -replace $char, $chars[$key]
		}
	}

	$passBuilder.append($websc)
	$passBuilder.append($specialChar)
	
	$secureNumber = Read-Host "Enter the tempPass " -AsSecureString
	Write-Host ""
	$tempPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureNumber))


	$num = GenerateNumber $tempPass

	if ($num -eq $null){
		for ($i=0; $i -lt 3; $i++){
			Start-Sleep -Milliseconds 873
			Write-Host "^"
		}
			
		Write-Host "can not generate"
		return
	}

	$passBuilder.append($num)
	
	$finalPass = $passBuilder.ToString()
	
	Set-Clipboard -Value $finalPass
}

function GenerateNumber{
	param(
		[int]$tempPass
	)
	
	$numberString = $tempPass.ToString()

	if ($numberString.Length -ne 6){
		Write-Host "Not 6 digits...?"
		return
	}
	
	$seed = $tempPass
	
	$num = Get-Random -Minimum 100 -Maximum 1000 -SetSeed $seed

	return $num.ToString()
}


Generate-Password -username $u -domain $d
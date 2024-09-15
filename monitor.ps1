<#
This script is used to auto-delete files that are of certain type and has not been updated for specified number of days

Note : Not specifying any file type will delete all the files in the specified directory
#>

param(
    [string]$type, 
    [int]$days
)

$extensions = @()

if ($type -eq "img"){
    $extensions = @('.img', '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff')
} elseif ($type -eq "pdf"){
    $extensions = @('.pdf')
} elseif ($type) {
    $extensions = @($type)
}

Write-Host "Ready to delete $($type) files"

$targetPath = "C:/Users/Vikash maurya/Downloads/test"

function deleteFiles {
    param(
        [string]$targetPath, 
        [string[]]$extensions, 
        [int]$days
    )

    $files = Get-ChildItem -Path $targetPath -File
    
    if ($files.Count -eq 0) {
        Write-Host "Empty directory"
        return
    }
    
    $delCount = 0

    foreach ($file in $files) {
        if (-not $extensions -or $extensions.Count -eq 0) {
            if ($file.LastWriteTime -lt (Get-Date).AddDays(-$days)) {
                try {
                    Remove-Item -Path $file.FullName -Force
                    $delCount += 1
                    Start-Sleep -Milliseconds 500 
                    Write-Host "`n^"
                    Write-Host "Deleted $($file.FullName)"
                } catch {
                    Write-Host "Failed to delete $($file.FullName)"
                }
            }
        } elseif ($file.Extension -in $extensions -and $file.LastWriteTime -lt (Get-Date).AddDays(-$days)) {
            try {
                Remove-Item -Path $file.FullName -Force
                $delCount += 1
                Start-Sleep -Milliseconds 500 
                Write-Host "`n^"
                Write-Host "Deleted $($file.FullName)"
            } catch {
                Write-Host "Failed to delete $($file.FullName)"
            }
        }
    }

    if ($delCount -eq 0) {
        Write-Host "Nothing to remove here"    
    } else {
        Write-Host "`n($delCount)file(s) removed"
    }
}

function deleteAll {
    param(
        [string]$targetPath
    )

    $files = Get-ChildItem -Path $targetPath -File
    
    if ($files.Count -eq 0) {
        Write-Host "Empty directory"
        return
    }
    
    $delCount = 0
    
    foreach ($file in $files) {
        try {
            Remove-Item -Path $file.FullName -Force
            $delCount += 1
            Start-Sleep -Milliseconds 500 
            Write-Host "`n^"
            Write-Host "Deleted $($file.FullName)"
        } catch {
            Write-Host "Failed to delete $($file.FullName)"
        }
    }

    if ($delCount -eq 0) {
        Write-Host "Nothing to remove here"    
    } else {
        Write-Host "`n($delCount)file(s) removed"
    }
}

if (-not $days) {
    deleteAll $targetPath
} else {
    deleteFiles $targetPath $extensions -days $days
}

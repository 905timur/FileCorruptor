$targetDirectory = Read-Host "Enter the target directory path"

if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    Write-Host "Invalid directory path!"
    Exit
}

$numFilesToCorrupt = 5
$fileSize = 1024

function Generate-RandomData {
    param($size)

    $randomData = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count $size | ForEach-Object {[char]$_})
    return $randomData
}

$files = Get-ChildItem -Path $targetDirectory -File | Get-Random -Count $numFilesToCorrupt

foreach ($file in $files) {
    $filePath = $file.FullName

    $randomData = Generate-RandomData -size $fileSize
    Set-Content -Path $filePath -Value $randomData

    Write-Host "Corrupted file: $filePath"
}

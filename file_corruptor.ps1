# Prompt user for the target directory
$targetDirectory = Read-Host "Enter the target directory path"

# Validate directory path
if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    Write-Host "Invalid directory path!"
    Exit
}

# Set the number of files to corrupt and file size
$numFilesToCorrupt = 5
$fileSize = 1024

# Generate random data
function Generate-RandomData {
    param($size)

    $randomData = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count $size | ForEach-Object {[char]$_})
    return $randomData
}

# Corrupt files in the target directory
$files = Get-ChildItem -Path $targetDirectory -File | Get-Random -Count $numFilesToCorrupt

foreach ($file in $files) {
    $filePath = $file.FullName

    $randomData = Generate-RandomData -size $fileSize
    Set-Content -Path $filePath -Value $randomData

    Write-Host "Corrupted file: $filePath"
}

param($targetDirectory, $numFilesToCorrupt, $fileSize)

if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    Write-Host "Invalid directory path!"
    Exit
}

function Generate-RandomData {
    param($size)

    $randomData = New-Object byte[] $size
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $rng.GetBytes($randomData)
    return [System.Text.Encoding]::Default.GetString($randomData)
}

$files = Get-ChildItem -Path $targetDirectory -File | Get-Random -Count $numFilesToCorrupt

try {
    foreach ($file in $files) {
        $filePath = $file.FullName

        $randomData = Generate-RandomData -size $fileSize
        Set-Content -Path $filePath -Value $randomData

        Write-Host "Corrupting file: $filePath"
    }
} catch {
    Write-Host "An error occurred: $_"
}

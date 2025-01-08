#v1.1.0 12/24

$targetDirectory = Read-Host "Enter the target directory path"

if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    Write-Host "Invalid directory path!"
    Exit
}

$numFilesToCorrupt = 5000
$fileSize = 1024000
$chunkSize = 1024  # Writing in smaller chunks to avoid memory issues

function Generate-RandomData {
    param($size)

    $randomData = [byte[]]::new($size)
    [System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($randomData)
    return $randomData
}

$files = Get-ChildItem -Path $targetDirectory -File | Get-Random -Count $numFilesToCorrupt

foreach ($file in $files) {
    $filePath = $file.FullName

    try {
        $fileStream = [System.IO.File]::Open($filePath, [System.IO.FileMode]::Create)
        try {
            $remainingSize = $fileSize
            while ($remainingSize -gt 0) {
                $currentChunkSize = [math]::Min($chunkSize, $remainingSize)
                $randomData = Generate-RandomData -size $currentChunkSize
                $fileStream.Write($randomData, 0, $randomData.Length)
                $remainingSize -= $currentChunkSize
            }
            Write-Host "Corrupted file: $filePath"
        }
        finally {
            $fileStream.Close()
        }
    }
    catch {
        Write-Host "Failed to corrupt file: $filePath - $_"
    }
}

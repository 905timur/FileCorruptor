# File Corruptor Script v1.2.0

$targetDirectory = Read-Host "Enter the target directory path"

if (-not (Test-Path -Path $targetDirectory -PathType Container)) {
    Write-Host "Invalid directory path!"
    Exit
}

$numFilesToCorrupt = 5000
$fileSize = 1024000
$chunkSize = 1024  # Writing in smaller chunks to avoid memory issues
$logFile = "$targetDirectory\corruption_log.txt"

# Function to generate random data
function Generate-RandomData {
    param($size)

    $randomData = [byte[]]::new($size)
    [System.Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($randomData)
    return $randomData
}

# Function to corrupt a file
function Corrupt-File {
    param($file)

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
            Write-Output "Corrupted file: $filePath" | Out-File -Append -FilePath $logFile
        }
        finally {
            $fileStream.Close()
        }
    }
    catch {
        Write-Output "Failed to corrupt file: $filePath - $_" | Out-File -Append -FilePath $logFile
    }
}

# Parallel processing of file corruption
function Parallel-Corrupt {
    param($files)

    $totalFiles = $files.Count
    $progress = 0
    $sync = [System.Collections.Concurrent.ConcurrentQueue[object]]::new()

    $files | ForEach-Object -Parallel {
        $using:Corrupt-File -file $_
        $sync.Enqueue($true) # Track progress
    } -ThrottleLimit 10 # Limit number of parallel tasks

    # Progress bar loop
    while ($true) {
        $completed = $sync.Count
        $progress = [math]::Min(($completed / $totalFiles) * 100, 100)
        Write-Progress -Activity "Corrupting Files" -PercentComplete $progress -Status "$completed of $totalFiles files corrupted..."
        if ($completed -ge $totalFiles) { break }
        Start-Sleep -Seconds 1
    }
}

# Main Execution
Write-Output "Corruption started at $(Get-Date)" | Out-File -FilePath $logFile

try {
    $files = Get-ChildItem -Path $targetDirectory -File | Get-Random -Count $numFilesToCorrupt
    Parallel-Corrupt $files
    Write-Output "Corruption completed at $(Get-Date)" | Out-File -Append -FilePath $logFile
    Write-Host "Corruption complete! Log file saved at: $logFile"
}
catch {
    Write-Output "An error occurred: $_" | Out-File -Append -FilePath $logFile
    Write-Host "An error occurred. Check the log file for details: $logFile"
}

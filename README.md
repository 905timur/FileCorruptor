### File Corruptor v1.2.0
This PowerShell script is a utility designed to corrupt files within a specified directory by overwriting them with random data. It supports advanced features like logging, error handling, parallel processing, and a progress bar to make the process efficient and user-friendly.

---

## Features

- **Targeted Corruption**: Corrupts a random selection of files from a directory.
- **Custom File Parameters**: Adjustable number of files to corrupt and file size.
- **Parallel Processing**: Corrupts files simultaneously for faster execution.
- **Progress Tracking**: Displays a progress bar during the operation.
- **Error Logging**: Logs the details of successful and failed corruption attempts.
- **Chunked Writes**: Prevents memory issues by writing random data in smaller chunks.

---

## Usage

### Prerequisites
- PowerShell 7.0 or later is recommended for optimal performance.
- Ensure you have write permissions to the target directory.

### Running the Script
1. Clone or download this repository.
2. Open a PowerShell terminal and navigate to the script's directory.
3. Run the script using the following command:
   ```powershell
   .\FileCorruptor.ps1

---

### Script Workflow
- **Input Validation**: Ensures the specified directory path is valid.
- **Random File Selection**: Selects a specified number of files to corrupt.
- **File Corruption**: Overwrites each file with random data, using chunked writes to avoid memory issues.
- **Logging**: Logs details of the operation (e.g., file paths, errors) to a corruption_log.txt file in the target directory.
- **Parallel Processing**: Utilizes parallelization for efficiency.
- **Progress Bar**: Provides real-time feedback on the process.

### Log File
- All operation results are saved in corruption_log.txt in the target directory.
- The log file includes:
  - File paths of successfully corrupted files.
  - Details of any failures with error messages.
  - Start and end timestamps of the operation.

### Example Output
```
Corruption started at 1/7/2025 10:00:00 AM
Corrupted file: C:\TargetDir\File1.txt
Corrupted file: C:\TargetDir\File2.jpg
Failed to corrupt file: C:\TargetDir\File3.png - Access to the file is denied
Corruption completed at 1/7/2025 10:05:00 AM
```
## Customization

### Adjustable Parameters
You can modify the following parameters directly in the script:

- **`$numFilesToCorrupt`**: Number of files to corrupt (default: `5000`).
- **`$fileSize`**: Target size for corrupted files in bytes (default: `1024000`).
- **`$chunkSize`**: Size of each data chunk written to files (default: `1024`).

---

## Safety Notes
- **Caution**: This script is destructive and will irreversibly corrupt files. Use it responsibly.
- **Backup**: Ensure you have backups of important data before running the script.

---

## License
This script is distributed under the MIT License.

---

## Contributions
Feel free to submit issues or pull requests to enhance the script.

---

## Disclaimer
The authors are not responsible for any data loss or damages caused by using this script. Use it at your own risk.

---

### Changelog: 

## v1.2.0
- **Logging**: 
  - Logs details of corrupted files (successes and failures) to a `corruption_log.txt` file in the target directory.
  - Includes timestamps for the start and end of the operation.

- **Error Handling Enhancements**:
  - Improved error handling to gracefully manage failures.
  - Errors are captured and logged with detailed messages.

- **Parallel Processing**:
  - Implemented parallel file corruption using `ForEach-Object -Parallel` for faster execution.
  - Added a throttle limit to prevent excessive resource consumption.

- **Progress Bar**:
  - Introduced a progress bar to provide real-time feedback during the operation.

### Changed
- **Code Refactoring**:
  - Modularized the script with functions (`Generate-RandomData`, `Corrupt-File`, `Parallel-Corrupt`) for improved readability and maintainability.

## v1.0.1 
- Changed chunk size to avoid memory leaks. 

# Function to display a progress bar using "|" with color scale
function Show-ProgressBar {
    param (
        [int]$value,
        [string]$label
    )
    $consoleWidth = [System.Console]::WindowWidth - 2
    $barLength = $consoleWidth - $label.Length - 10  # Adjust length for brackets and percentage
    $filledLength = [math]::Round(($value / 100) * $barLength)
    $emptyLength = $barLength - $filledLength
    $filledBar = "|" * $filledLength
    $emptyBar = " " * $emptyLength
    $percent = "{0:N2}" -f $value

    # Determine color based on value
    $color = if ($value -le 25) {
        "Green"
    } elseif ($value -le 75) {
        "Yellow"
    } else {
        "Red"
    }

    Write-Host -NoNewline "$label ["
    Write-Host -NoNewline "$filledBar" -ForegroundColor $color
    Write-Host -NoNewline "$emptyBar] $percent`%"
}

# Function to get and display system information
function Get-SystemInfo {
    $cpuUsage = (Get-Counter -Counter "\Processor(_Total)\% Processor Time").CounterSamples.CookedValue
    $memory = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalMemory = $memory.TotalVisibleMemorySize / 1MB
    $freeMemory = $memory.FreePhysicalMemory / 1MB
    $usedMemory = $totalMemory - $freeMemory
    $memoryUsage = ($usedMemory / $totalMemory) * 100

    Clear-Host
    $consoleWidth = [System.Console]::WindowWidth - 2

    $horizontalLine = "─" * $consoleWidth
    $title = " System Monitoring "
    $padding = [math]::Floor(($consoleWidth - $title.Length) / 2)
    $rightPadding = $consoleWidth - $padding - $title.Length

    $titleLine = "│" + (" " * $padding) + $title + (" " * $rightPadding) + "│"

    Write-Host "┌$horizontalLine┐" -ForegroundColor Green
    Write-Host $titleLine -ForegroundColor Green
    Write-Host "└$horizontalLine┘" -ForegroundColor Green

    Show-ProgressBar -value $cpuUsage -label "CPU Usage:    "
    Write-Host
    Show-ProgressBar -value $memoryUsage -label "Memory Usage: "
    Write-Host
    Write-Host "$horizontalLine" -ForegroundColor Green

    Write-Host "Top Processes by CPU Usage:" -ForegroundColor Yellow
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | ForEach-Object {
        $process = $_
        try {
            $path = $process.Path
        } catch {
            $path = "N/A"
        }
        [PSCustomObject]@{
            Name       = $process.Name
            CPU        = $process.CPU
            MemoryMB   = [math]::Round($process.WorkingSet64 / 1MB, 2)
            FilePath   = $path
        }
    } | Format-Table -Property Name, CPU, MemoryMB, FilePath -AutoSize
}

# Monitor system information every 5 seconds
while ($true) {
    Get-SystemInfo
    Start-Sleep -Seconds 5
}

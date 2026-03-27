function Get-Tools {
    $toolsPath = Join-Path $PSScriptRoot "tools"
    return Get-ChildItem -Path $toolsPath -Filter *.ps1 | Sort-Object Name
}

function Show-Menu($tools) {
    Clear-Host
    Write-Host "==== Windows Tools Menu ====" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $tools.Count; $i++) {
        $displayName = $tools[$i].BaseName -replace "_", " "
        Write-Host ("[{0}] {1}" -f ($i + 1), $displayName)
    }

    Write-Host ""
    Write-Host "[0] Exit"
    Write-Host ""
}

while ($true) {
    $tools = Get-Tools

    if ($tools.Count -eq 0) {
        Write-Host "No tools found in /tools folder." -ForegroundColor Red
        break
    }

    Show-Menu $tools

    $input = Read-Host "Enter number"

    # Ensure it's a valid number
    if ($input -match '^\d+$') {
        $choice = [int]$input

        if ($choice -eq 0) {
            Write-Host "Exiting..."
            break
        }

        if ($choice -ge 1 -and $choice -le $tools.Count) {
            $tool = $tools[$choice - 1]

            Clear-Host
            Write-Host "Running: $($tool.BaseName)" -ForegroundColor Yellow
            Write-Host ""

            try {
                & $tool.FullName
            }
            catch {
                Write-Host "Error running tool:" -ForegroundColor Red
                Write-Host $_
            }

            Write-Host ""
            Read-Host "Press Enter to return to menu"
        }
        else {
            Write-Host "Invalid number." -ForegroundColor Red
            Start-Sleep 1
        }
    }
    else {
        Write-Host "Please enter a number only." -ForegroundColor Red
        Start-Sleep 1
    }
}

function Get-Tools {
    $toolsPath = Join-Path $PSScriptRoot "tools"
    return Get-ChildItem -Path $toolsPath -Filter *.ps1 | Sort-Object Name
}

function Show-Menu($tools) {
    Clear-Host
    Write-Host "==== Windows Tools Menu ====" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $tools.Count; $i++) {
        $name = $tools[$i].BaseName -replace "_", " "
        Write-Host "$($i+1). $name"
    }

    Write-Host ""
    Write-Host "R. Refresh tools"
    Write-Host "0. Exit"
}

do {
    $tools = Get-Tools
    Show-Menu $tools

    $choice = Read-Host "Select option"

    if ($choice -eq "0") { break }

    if ($choice -eq "R" -or $choice -eq "r") {
        Write-Host "Refreshing..." -ForegroundColor Yellow
        Start-Sleep 1
        continue
    }

    if ($choice -as [int] -and $choice -gt 0 -and $choice -le $tools.Count) {
        $tool = $tools[$choice - 1]

        Write-Host ""
        Write-Host "Running $($tool.BaseName)..." -ForegroundColor Yellow

        try {
            & $tool.FullName
        }
        catch {
            Write-Host "Error: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Invalid selection" -ForegroundColor Red
    }

    Write-Host ""
    Pause

} while ($true)

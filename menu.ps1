function Show-Menu($tools) {
    Clear-Host
    Write-Host "==== Windows Tools Menu ====" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $tools.Count; $i++) {
        Write-Host "$($i+1). $($tools[$i].BaseName)"
    }

    Write-Host ""
    Write-Host "0. Exit"
}

function Get-Tools {
    $toolsPath = Join-Path $PSScriptRoot "tools"
    return Get-ChildItem -Path $toolsPath -Filter *.ps1
}

do {
    $tools = Get-Tools
    Show-Menu $tools

    $choice = Read-Host "Select an option"

    if ($choice -eq "0") {
        break
    }

    if ($choice -as [int] -and $choice -gt 0 -and $choice -le $tools.Count) {
        $selectedTool = $tools[$choice - 1]

        Write-Host ""
        Write-Host "Running $($selectedTool.BaseName)..." -ForegroundColor Yellow

        try {
            & $selectedTool.FullName
        }
        catch {
            Write-Host "Error running tool: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Invalid selection" -ForegroundColor Red
    }

    Write-Host ""
    Pause

} while ($true)

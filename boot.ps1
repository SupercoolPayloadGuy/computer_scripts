$owner = "SupercoolPayloadGuy"
$repo = "computer_scripts"
$branch = "main"

$baseApi = "https://api.github.com/repos/$owner/$repo/contents"
$rawBase = "https://raw.githubusercontent.com/$owner/$repo/$branch"

$temp = "$env:TEMP\windows-tools"

# Clean + recreate
Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $temp | Out-Null
New-Item -ItemType Directory -Force -Path "$temp\tools" | Out-Null

Write-Host "Downloading menu..."

# Download menu.ps1
Invoke-WebRequest "$rawBase/menu.ps1" -OutFile "$temp\menu.ps1"

Write-Host "Fetching tools list from GitHub..."

# Get tools folder contents via API
$tools = Invoke-RestMethod "$baseApi/tools"

foreach ($file in $tools) {
    if ($file.name -like "*.ps1") {
        $downloadUrl = $file.download_url
        $destination = Join-Path "$temp\tools" $file.name

        Write-Host "Downloading $($file.name)..."
        Invoke-WebRequest $downloadUrl -OutFile $destination
    }
}

Write-Host "Launching menu..."
Start-Sleep 1

& "$temp\menu.ps1"

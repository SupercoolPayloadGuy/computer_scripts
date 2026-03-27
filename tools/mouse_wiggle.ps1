# mouse_wiggle.ps1
if ([Environment]::UserInteractive) {
    Add-Type -AssemblyName System.Windows.Forms

    for ($i = 0; $i -lt 20; $i++) {
        $pos = [System.Windows.Forms.Cursor]::Position
        [System.Windows.Forms.Cursor]::Position = New-Object Drawing.Point($pos.X + 12, $pos.Y)
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.Cursor]::Position = $pos
    }
} else {
    Write-Host "Mouse wiggle requires an interactive desktop."
}

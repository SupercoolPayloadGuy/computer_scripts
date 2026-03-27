# capslock_flicker.ps1
Add-Type -AssemblyName System.Windows.Forms

if ([Environment]::UserInteractive) {
    $initial = [console]::CapsLock

    for ($i = 0; $i -lt 10; $i++) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
        Start-Sleep -Milliseconds 200
    }

    # Restore original state
    if ([console]::CapsLock -ne $initial) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
    }
} else {
    Write-Host "Caps Lock flicker requires an interactive desktop."
}

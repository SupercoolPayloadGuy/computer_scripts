# fake_update.ps1
Add-Type -AssemblyName System.Windows.Forms

function Show-Message($text, $title="Windows Update") {
    if ([Environment]::UserInteractive) {
        # ServiceNotification allows popups even from background/non-interactive session
        [System.Windows.Forms.MessageBox]::Show(
            $text,
            $title,
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information,
            [System.Windows.Forms.MessageBoxDefaultButton]::Button1,
            [System.Windows.Forms.MessageBoxOptions]::ServiceNotification
        )
    } else {
        Write-Host "$title: $text"
    }
}

# Step 1: Show updating message
Show-Message "Installing updates. System will restart shortly..." 

Start-Sleep 3

# Step 2: Show “still working” message
Show-Message "Still installing updates..." 

Start-Sleep 3

# Step 3: Show completion
Show-Message "Update complete! Restart required." 

Start-Sleep 2

# Optional: actually restart (commented out by default)
# Restart-Computer -Force
Write-Host "NOTE: Restart is disabled for safety. Uncomment the Restart-Computer line to enable."

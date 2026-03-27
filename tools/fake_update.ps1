Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show(
    "Installing updates. System will restart.",
    "Windows Update",
    0,
    64
)

Start-Sleep -Seconds 5

Restart-Computer -Force

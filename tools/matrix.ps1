# matrix_rain.ps1
if ([Environment]::UserInteractive) {
    Add-Type -AssemblyName System.Windows.Forms

    $form = New-Object Windows.Forms.Form
    $form.Text = "System Activity"
    $form.Width = 600
    $form.Height = 400

    $box = New-Object Windows.Forms.RichTextBox
    $box.Dock = "Fill"
    $box.BackColor = "Black"
    $box.ForeColor = "Lime"
    $box.Font = "Consolas, 10"
    $form.Controls.Add($box)

    $form.Show()

    for ($i = 0; $i -lt 200; $i++) {
        $line = -join ((33..126) | Get-Random -Count 60 | ForEach-Object {[char]$_})
        $box.AppendText("$line`n")
        Start-Sleep -Milliseconds 50
    }

    Start-Sleep 2
    $form.Close()
} else {
    # SSH / non-interactive fallback
    for ($i = 0; $i -lt 50; $i++) {
        $line = -join ((33..126) | Get-Random -Count 60 | ForEach-Object {[char]$_})
        Write-Host $line
        Start-Sleep -Milliseconds 50
    }
}

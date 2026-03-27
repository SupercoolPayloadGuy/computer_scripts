# fake_update.ps1
# Displays a convincing fake Windows Update progress window.
# Harmless prank — does NOT modify system files or restart unless you uncomment the line at the bottom.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ── Build the form ────────────────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text            = "Windows Update"
$form.Size            = New-Object System.Drawing.Size(520, 220)
$form.StartPosition   = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox     = $false
$form.MinimizeBox     = $false
$form.ControlBox      = $false          # hides the X so it can't be closed easily
$form.BackColor       = [System.Drawing.Color]::White
$form.TopMost         = $true

# Windows Update shield icon (built-in system icon fallback)
try {
    $form.Icon = [System.Drawing.SystemIcons]::Shield
} catch {}

# Header label
$lblHeader = New-Object System.Windows.Forms.Label
$lblHeader.Text      = "Installing updates..."
$lblHeader.Font      = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Regular)
$lblHeader.Location  = New-Object System.Drawing.Point(20, 18)
$lblHeader.Size      = New-Object System.Drawing.Size(470, 30)
$form.Controls.Add($lblHeader)

# Sub-label (detail text)
$lblDetail = New-Object System.Windows.Forms.Label
$lblDetail.Text      = "Please don't turn off your PC. This will take a while."
$lblDetail.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
$lblDetail.ForeColor = [System.Drawing.Color]::FromArgb(96, 96, 96)
$lblDetail.Location  = New-Object System.Drawing.Point(20, 52)
$lblDetail.Size      = New-Object System.Drawing.Size(470, 22)
$form.Controls.Add($lblDetail)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 85)
$progressBar.Size     = New-Object System.Drawing.Size(470, 22)
$progressBar.Minimum  = 0
$progressBar.Maximum  = 100
$progressBar.Value    = 0
$progressBar.Style    = "Continuous"
$form.Controls.Add($progressBar)

# Percentage label
$lblPercent = New-Object System.Windows.Forms.Label
$lblPercent.Text      = "0%"
$lblPercent.Font      = New-Object System.Drawing.Font("Segoe UI", 9)
$lblPercent.ForeColor = [System.Drawing.Color]::FromArgb(64, 64, 64)
$lblPercent.Location  = New-Object System.Drawing.Point(20, 115)
$lblPercent.Size      = New-Object System.Drawing.Size(470, 20)
$form.Controls.Add($lblPercent)

# Divider line
$divider = New-Object System.Windows.Forms.Label
$divider.BorderStyle = "Fixed3D"
$divider.Location    = New-Object System.Drawing.Point(0, 145)
$divider.Size        = New-Object System.Drawing.Size(520, 2)
$form.Controls.Add($divider)

# Footer label
$lblFooter = New-Object System.Windows.Forms.Label
$lblFooter.Text      = "Windows Update"
$lblFooter.Font      = New-Object System.Drawing.Font("Segoe UI", 8)
$lblFooter.ForeColor = [System.Drawing.Color]::Gray
$lblFooter.Location  = New-Object System.Drawing.Point(20, 155)
$lblFooter.Size      = New-Object System.Drawing.Size(470, 20)
$form.Controls.Add($lblFooter)

# ── Progress stages ───────────────────────────────────────────────────────────
# Each entry: [target %, header text, detail text, pause at end (ms)]
$stages = @(
    @{ Target=15; Header="Downloading updates (1 of 3)...";      Detail="Fetching update KB5034441 — Security Update for Windows 11";       Pause=800  },
    @{ Target=30; Header="Downloading updates (2 of 3)...";      Detail="Fetching update KB5034763 — .NET Framework 4.8.1 Cumulative";      Pause=500  },
    @{ Target=45; Header="Downloading updates (3 of 3)...";      Detail="Fetching update KB5035853 — Windows Defender Definition Update";   Pause=800  },
    @{ Target=62; Header="Installing updates...";                 Detail="Applying KB5034441 — do not power off your device";               Pause=1200 },
    @{ Target=75; Header="Installing updates...";                 Detail="Applying KB5034763 — configuring .NET components";                Pause=900  },
    @{ Target=88; Header="Installing updates...";                 Detail="Applying KB5035853 — updating security definitions";              Pause=700  },
    @{ Target=97; Header="Finalizing changes...";                 Detail="Completing installation and verifying integrity";                 Pause=1500 },
    @{ Target=100; Header="Updates installed successfully.";      Detail="Your device is up to date. A restart is required to finish.";     Pause=2000 }
)

# ── Show the form non-blocking, then animate ──────────────────────────────────
$form.Show()
$form.Refresh()

foreach ($stage in $stages) {
    $lblHeader.Text = $stage.Header
    $lblDetail.Text = $stage.Detail
    $form.Refresh()

    # Smoothly advance the bar to the target value
    $start = $progressBar.Value
    $end   = $stage.Target
    for ($i = $start; $i -le $end; $i++) {
        $progressBar.Value = $i
        $lblPercent.Text   = "$i% complete"
        $form.Refresh()
        Start-Sleep -Milliseconds (Get-Random -Minimum 30 -Maximum 90)
    }

    Start-Sleep -Milliseconds $stage.Pause
}

# ── Brief "restart" countdown then close ─────────────────────────────────────
for ($sec = 5; $sec -ge 1; $sec--) {
    $lblDetail.Text = "Restarting in $sec second$(if($sec -ne 1){'s'})..."
    $form.Refresh()
    Start-Sleep -Seconds 1
}

$form.Close()

# Uncomment the line below to actually restart the computer:
 Restart-Computer -Force

Write-Host "Fake update complete. Restart is disabled — uncomment Restart-Computer to enable."

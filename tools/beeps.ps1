# random_beeps.ps1
for ($i = 0; $i -lt 10; $i++) {
    [console]::beep((Get-Random -Min 400 -Max 1200), 200)
    Start-Sleep -Milliseconds 150
}

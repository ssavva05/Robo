# Confirm-Action.ps1

param (
    [string]$Message = "Are you sure you want to continue?",
    [string]$Title = "Confirmation"
)

Add-Type -AssemblyName System.Windows.Forms

$result = [System.Windows.Forms.MessageBox]::Show(
    $Message,
    $Title,
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Write-Output "Yes"
} else {
    Write-Output "No"
}

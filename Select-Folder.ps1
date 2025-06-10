<#
.SYNOPSIS
 Prompts the user to pick a folder (local drive, mapped drive **or UNC network share**).

.DESCRIPTION
 Uses the **OpenFileDialog** trick instead of *FolderBrowserDialog* so that the Network
 node is shown and UNC paths (\\server\share) can be picked on every version of
 Windows.

.PARAMETER Title
 Caption shown on the dialog.

.EXAMPLE
 $src = .\Select-Folder.ps1 -Title 'Pick SOURCE folder'
 $dst = .\Select-Folder.ps1 -Title 'Pick DESTINATION folder'
 robocopy $src $dst /MIR
#>

param(
    [string]$Title = 'Select a folder'
)

# Load WinForms once
Add-Type -AssemblyName System.Windows.Forms

$dlg = New-Object System.Windows.Forms.OpenFileDialog
$dlg.Title            = $Title
$dlg.Filter           = 'Folders|*.folder'   # dummy filter so no real files are shown
$dlg.CheckFileExists  = $false               # allow picking non‑existent path in dialog
$dlg.CheckPathExists  = $true
$dlg.ValidateNames    = $false               # required so the dummy filename is accepted
$dlg.Multiselect      = $false
$dlg.FileName         = 'Select this folder' # text shown in the filename box

# Show the dialog
if ($dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    # When the user clicks **Open**, OpenFileDialog returns the selected *folder* plus
    # the dummy filename.  Strip it off so that only the folder remains.
    Split-Path -Path $dlg.FileName -Parent
    return
}

throw 'Folder selection cancelled by user.'

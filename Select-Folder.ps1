param (
    [string]$title
)

# Function to show a folder picker dialog
function Select-Folder {
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $title
    $folderBrowser.ShowNewFolderButton = $false

    if ($folderBrowser.ShowDialog() -eq 'OK') {
        return $folderBrowser.SelectedPath
    }
    return $null
}

# Show the folder picker dialog and output the selected path
$path = Select-Folder
if ($path) {
    Write-Output $path
} else {
    Write-Output ""
}

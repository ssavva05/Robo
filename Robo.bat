@echo off
setlocal

:: Prompt to select the source directory
msg * "Select Source Directory"
rem Call PowerShell to select the source folder
for /f "delims=" %%i in ('powershell -File "Select-Folder.ps1" -title "Select Source Folder"') do set "source=%%i"

:: Prompt to select the destination directory
msg * "Select Destination Directory"
rem Call PowerShell to select the destination folder
for /f "delims=" %%i in ('powershell -File "Select-Folder.ps1" -title "Select Destination Folder"') do set "destination=%%i"

:: Check if the source and destination are set
if not defined source (
    echo Source folder was not selected. Exiting.
    pause
    exit /b 1
)

if not defined destination (
    echo Destination folder was not selected. Exiting.
    pause
    exit /b 1
)

:: Display confirmation dialog
for /f "delims=" %%i in ('powershell -File "Confirm-Action.ps1" -Message "Mirroring from %source% to %destination%. Do you want to proceed?" -Title "Confirm Operation"') do set "confirm=%%i"

if /i "%confirm%"=="Yes" (
    echo Proceeding with mirroring from "%source%" to "%destination%".
    
    :: Mirror the contents from source to destination using robocopy
    echo Mirroring from "%source%" to "%destination%"
    robocopy "%source%" "%destination%" /MIR /E /Z /XA:SH /XF desktop.ini /XD "System Volume Information"

    :: Check the result of robocopy
    set errorlevel=%errorlevel%

    if %errorlevel% geq 8 (
        echo Robocopy encountered a failure. Exit Code: %errorlevel%.
        msg * "Robocopy encountered a failure. Exit Code: %errorlevel%."
    ) else if %errorlevel% geq 4 (
        echo Robocopy completed with warnings or minor issues. Exit Code: %errorlevel%.
        msg * "Robocopy completed with warnings or minor issues. Exit Code: %errorlevel%."
    ) else (
        echo Robocopy completed successfully. Exit Code: %errorlevel%.
        msg * "Robocopy completed successfully. Exit Code: %errorlevel%."
    )
    
    echo ------------------------------------------------------------------------------
    echo Exit Code 0: No files were copied.
    echo Exit Code 1: One or more files were copied successfully.
    echo Exit Code 2: Some extra files or directories were detected and deleted.
    echo Exit Code 3: Some files were copied successfully, and some extra files were deleted.
    echo Exit Code 4: Some mismatched files or directories were detected.
    echo Exit Code 5: Some files were copied successfully, and some mismatched files were detected.
    echo Exit Code 6: Some extra files were deleted, and mismatched files were detected.
    echo Exit Code 7: Files were copied, extra files were deleted, and mismatched files were detected.
    echo Exit Code 8: Some files or directories could not be copied.
    echo Exit Code 8-15: Various errors occurred, which indicate failures.
    echo Exit Code 16: Serious error occurred.
    echo ------------------------------------------------------------------------------
) else (
    echo Operation cancelled by user.
)

pause

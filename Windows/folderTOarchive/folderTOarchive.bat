@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo folderTOarchive %folderTOarchive_Version%&echo.
goto UserInput

REM User input.
:UserInput
set /p "SourceDir=Enter the directory path to archive: (e.g. Path\To\Folder) "
set /p "ArchivePath=Enter the destination .ZIP path (e.g. Path\To\File.zip): "
goto Check

REM Check.
:Check
if "%SourceDir%"=="" goto EmptyDir
if "%ArchivePath%"=="" goto EmptyDir
goto Clean

REM Empty directory.
:EmptyDir
echo No valid directory or output path was provided.
goto End

REM Clean up potential old file.
:Clean
if exist "%ArchivePath%" (
    echo Attempting to remove existing file...
    del /f /q "%ArchivePath%" 2>nul
    if exist "%ArchivePath%" (
        echo [ERROR] Could not delete existing zip. Please close the file and try again.
        pause
        exit /b
    )
)
goto Compress

REM Compress.
:Compress
echo Compressing files...
powershell -Command "Compress-Archive -Path '%SourceDir%' -DestinationPath '%ArchivePath%' -Force"
if %errorlevel% EQU 0 (
	echo.&echo Success! Created: %ArchivePath%
) else (
	echo.&echo [ERROR] An error occurred during compression.
)
goto End

REM End.
:End
endlocal
echo.& echo Done!
pause

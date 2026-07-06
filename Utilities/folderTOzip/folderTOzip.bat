@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo folderTOzip %folderTOzip_Version%&echo.

REM User input.
:UserInput
set /p "SourceDir=Enter the directory path to zip (e.g., C:\Path\To\Folder): "
set /p "ZipPath=Enter the destination ZIP path (e.g., C:\Path\To\Output.zip): "
goto Check

REM Check.
:Check
if "%SourceDir%"=="" goto EmptyDir
if "%ZipPath%"=="" goto EmptyDir
goto Clean

REM Empty directory.
:EmptyDir
echo No valid directory or output path was provided.
goto End

REM Clean up potential old file.
:Clean
if exist "%ZipPath%" (
    echo Attempting to remove existing file...
    del /f /q "%ZipPath%" 2>nul
    if exist "%ZipPath%" (
        echo [ERROR] Could not delete existing zip. Please close the file and try again.
        pause
        exit /b
    )
)
goto Compress

REM Compress.
:Compress
echo Compressing files...
powershell -Command "Compress-Archive -Path '%SourceDir%' -DestinationPath '%ZipPath%' -Force"
if %errorlevel% EQU 0 (
	echo.&echo Success! Created: %ZipPath%
) else (
	echo.&echo [ERROR] An error occurred during compression.
)
goto End

REM End.
:End
endlocal
echo.& echo Done!
pause

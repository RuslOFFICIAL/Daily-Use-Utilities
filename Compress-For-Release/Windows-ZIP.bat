@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo Windows-ZIP %DUU_Version%&echo.
goto CompressingProc

REM Compressing process.
:CompressingProc
REM Define paths relative to the script location.
set "SourceDir=%~dp0.."
set "StagingDir=%~dp0..\TempReleaseWin"
set "ZipFolder=%~dp0..\Releases"
set "ZipFile=%ZipFolder%\DUU_%DUU_Version%-Windows.zip"

echo Cleaning release folder...
for %%f in ("%ZipFolder%\DUU_*-Windows.zip") do (
	echo Removing old ZIP: "%%~nxf"...
	del "%%f" /f /q
)

echo Preparing release folder (excluding all .conf files)...
robocopy "%SourceDir%" "%StagingDir%" /E /XF *.lnk DUU-Linux.sh /XD TempReleaseWin TempReleaseLinux Releases .git Linux

echo.&echo Compressing into .zip file...
REM Create the output directory if it doesn't exist.
if not exist "%ZipFolder%" mkdir "%ZipFolder%"

REM Use PowerShell to compress the staging contents.
powershell -Command "Compress-Archive -Path '%StagingDir%\*' -DestinationPath '%ZipFile%' -Force"

echo.
echo Cleaning up temporary folders...
rmdir /s /q "%StagingDir%"
goto End

REM End.
:End
endlocal
echo.&echo Done!&echo Your release is ready inside the "Releases" folder.
pause&exit
@echo off
cd /d "%~dp0"
setlocal

REM Admin check.
net session >nul 2>&1
if %errorlevel% equ 0 (
	goto GR
) else (
	echo Failure: This script must be run as an Administrator.
	pause
	exit
)

REM Getting ready.
:GR
REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo CleanTemp %CleanTemp_Version%&echo.
set "TempDir=%TEMP%"
goto Confirm

REM Confirmation.
:Confirm
set /p "Confirmation=Are you sure you want to run this script? (Y/n) "
if /i not "%Confirmation%"=="Y" (
	echo Operation cancelled by user.
	pause
	exit
)
goto Deletion

REM Deletion
:Deletion
echo Deleting the contents of the folder "%TempDir%"...&echo.

REM Files.
echo Files
del /q /s "%TempDir%\*"

REM Directories.
echo.&echo Directories
for /d %%d in ("%TempDir%\*") do (
	echo Deleting directory: %%~nxd
	rd /s /q "%%d"
)
goto End

REM End.
:End
endlocal
echo.&echo Done!
pause

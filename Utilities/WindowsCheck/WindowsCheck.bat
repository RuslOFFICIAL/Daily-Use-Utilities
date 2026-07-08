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

echo WindowsCheck %WindowsCheck_Version%&echo.
goto Confirm

REM Confirmation.
:Confirm
set /p "Confirmation=Are you sure you want to run this script? (Y/n) "
if /i not "%Confirmation%"=="Y" (
	echo.&echo Operation cancelled by user.
	pause
	exit
)
goto Check

REM Check.
:Check
echo Running command "sfc /scannow"...
sfc /scannow
echo.&echo Running command "DISM /Online /Cleanup-Image /RestoreHealth"...
DISM /Online /Cleanup-Image /RestoreHealth
goto End

:End
endlocal
echo.&echo Done!
pause
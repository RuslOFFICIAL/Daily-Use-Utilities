@echo off
cd /d "%~dp0"
setlocal

REM Admin check.
net session >nul 2>&1
if %errorlevel% equ 0 (
	goto GR
) else (
	echo Failure: This script must be run as an Administrator.& echo.
	pause& exit
)

REM Getting ready.
:GR
REM Variables.
set "VariablesFileName=Variables.conf"
set "VariablesFile=..\Configs\%VariablesFileName%"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VARIABLES_FILE%'! & echo Check if you have that file or download it from GitHub repository! & echo.
)

echo SystemCheck %SystemCheck_Version%& echo.
goto Confirm

REM Confirmation.
:Confirm
set /p "Confirmation=Are you sure you want to run this script? (Y/n) "
if /i not "%Confirmation%"=="Y" (
	echo.& echo Operation cancelled by user.& echo.
	pause& exit
)
goto Check

REM Check.
:Check
echo Running command "sfc /scannow"...
sfc /scannow
echo.& echo Running command "DISM /Online /Cleanup-Image /RestoreHealth"...
DISM /Online /Cleanup-Image /RestoreHealth
goto End

:End
endlocal
echo.& echo Done!
pause
@echo off
cd /d "%~dp0"
setlocal

REM Admin check.
net session >nul 2>&1
if %errorlevel% equ 0 (
	goto GR
) else (
	echo Failure: This script must be run as an Administrator.& echo.
	pause
	exit
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

echo CleanTemp %CleanTemp_Version%& echo.
goto Confirm

REM Confirmation.
:Confirm
set /p "Confirmation=Are you sure you want to run this script? (Y/n) "
if /i not "%Confirmation%"=="Y" (
	echo.& echo Operation cancelled by user.& echo.
	pause& exit
)
echo. && goto Deletion

REM Deletion.
:Deletion
REM Temp folder.
set "TempDir=%TEMP%"
if "%TempDir%"=="" set "TempDir=%USERPROFILE%\AppData\Local\Temp"
if not exist "%TempDir%" mkdir "%TempDir%"

if not exist "%TempDir%\" (
    echo [ERROR] Could not resolve a valid Temp directory.& echo.
    pause& exit
)

REM Deletion.
echo Deleting the contents of the folder "%TempDir%"...& echo.

REM Files.
echo Files:
del /q /s "%TempDir%\*"

REM Directories.
echo.& echo Directories:
for /d %%d in ("%TempDir%\*") do (
	echo Deleting directory: %%~nxd
	rd /s /q "%%d"
)
goto End

REM End.
:End
endlocal
echo.& echo Done!
pause

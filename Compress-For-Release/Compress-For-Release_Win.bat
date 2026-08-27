@echo off
cd /d "%~dp0"
setlocal

REM Variables.
set "VariablesFileName=Variables.conf"
set "VariablesFile=..\Configs\%VariablesFileName%"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VariablesFile%'! & echo Check if you have that file or download it from GitHub repository! & echo.
)

echo Compress-For-Release_Win %DUU_Version%&echo.

REM Running files.
for %%f in ("%~dp0*.*") do (
    if not "%%~nxf"=="%~nx0" (
        echo Running "%%~nxf"...
        start "" "%%f"
    )
)

REM End.
echo.&echo Done!
pause

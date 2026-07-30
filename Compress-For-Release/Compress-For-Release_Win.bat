@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\Conf-Files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\Conf-Files\Variables.conf") do set "%%A=%%~B"
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

@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM .conf files.
if exist "..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo DUU-Launcher %DUU_Version%&echo.

REM Choices.
echo What script would you like to run?
echo [1] docxANDpdf&echo [2] folderTOzip&echo [3] pngANDjpg
echo.

choice /c 123 /n /m "Enter your choice (1, 2, 3): "

if %errorlevel%==3 goto pngANDjpg
if %errorlevel%==2 goto folderTOzip
if %errorlevel%==1 goto docxANDpdf

REM Results.
:docxANDpdf
set "ScriptName=docxANDpdf"
goto End

:folderTOzip
set "ScriptName=folderTOzip"
goto End

:pngANDjpg
set "ScriptName=pngANDjpg"
goto End

REM End.
:End
echo Running "%ScriptName%.bat"...&echo.
endlocal & set "ScriptPath=%~dp0..\Utilities\%ScriptName%\%ScriptName%.bat"
call "%ScriptPath%"
echo.&echo Done!
pause
exit

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
echo [1] docxTOpdf&echo [2] pdfTOdocx&echo [3] folderTOzip&echo [4] pngANDjpg
echo.

choice /c 1234 /n /m "Enter your choice (1, 2, 3, 4): "

if %errorlevel%==4 goto pngANDjpg
if %errorlevel%==3 goto folderTOzip
if %errorlevel%==2 goto pdfTOdocx
if %errorlevel%==1 goto docxTOpdf

REM Results.
:docxTOpdf
set "ScriptName=docxTOpdf"
goto End

:pdfTOdocx
set "ScriptName=pdfTOdocx"
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

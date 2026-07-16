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
echo [1] CleanTemp&echo [2] docxANDpdf&echo [3] folderTOarchive&echo [4] pngANDjpg&echo [5] SystemCheck 
echo.

choice /c 12345 /n /m "Enter your choice (1, 2, 3, 4, 5): "

if %errorlevel%==5 goto SystemCheck
if %errorlevel%==4 goto pngANDjpg
if %errorlevel%==3 goto folderTOarchive
if %errorlevel%==2 goto docxANDpdf
if %errorlevel%==1 goto CleanTemp

REM Results.
:CleanTemp
set "ScriptName=CleanTemp"
goto End

:docxANDpdf
set "ScriptName=docxANDpdf"
goto End

:folderTOarchive
set "ScriptName=folderTOarchive"
goto End

:pngANDjpg
set "ScriptName=pngANDjpg"
goto End

:WindowsCheck
set "ScriptName=WindowsCheck"
goto End

REM End.
:End
echo.& echo Running "%ScriptName%.bat"...&echo.
endlocal & set "ScriptPath=%~dp0%ScriptName%\%ScriptName%.bat"
call "%ScriptPath%"
echo.&echo Done!
pause
exit

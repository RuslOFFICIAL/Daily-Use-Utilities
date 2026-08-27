@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Variables.
set "VariablesFileName=Variables.conf"
set "VariablesFile=..\Configs\%VariablesFileName%"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VariablesFile%'! & echo Check if you have that file or download it from GitHub repository! & echo.
)

echo DUU-Launcher %DUU_Version%& echo.

REM Choices.
echo What script would you like to run?
echo [1] CleanTemp& echo [2] docxANDpdf& echo [3] folderTOarchive& echo [4] pngANDjpg& echo [5] SystemCheck 
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
goto RunScript

:docxANDpdf
set "ScriptName=docxANDpdf"
goto RunScript

:folderTOarchive
set "ScriptName=folderTOarchive"
goto RunScript

:pngANDjpg
set "ScriptName=pngANDjpg"
goto RunScript

:WindowsCheck
set "ScriptName=WindowsCheck"
goto RunScript

REM Run script.
:RunScript
echo.& echo Running "%ScriptName%.bat"...&echo.
endlocal & set "ScriptPath=%~dp0%ScriptName%.bat"
call "%ScriptPath%"
goto End

REM End.
:End
echo.& echo Done!
pause& exit

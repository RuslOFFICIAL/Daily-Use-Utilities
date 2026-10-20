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

:Menu
echo DUU-Launcher %DUU_Version% & echo.

REM Choices.
echo What script would you like to run?
echo [1] Exit
echo [2] CleanTemp & echo [3] docxANDpdf & echo [4] folderTOarchive & echo [5] pngANDjpg & echo [6] SystemCheck 
echo.

choice /c 123456 /n /m "Enter your choice (1, 2, 3, 4, 5, 6): "

if %errorlevel%==6 goto SystemCheck
if %errorlevel%==5 goto pngANDjpg
if %errorlevel%==4 goto folderTOarchive
if %errorlevel%==3 goto docxANDpdf
if %errorlevel%==2 goto CleanTemp
if %errorlevel%==1 goto End

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

:SystemCheck
set "ScriptName=SystemCheck"
goto RunScript

REM Run script.
:RunScript
echo. & echo Running "%ScriptName%.bat"... & echo.
set "ScriptPath=%~dp0%ScriptName%.bat"
setlocal
call "%ScriptPath%"
endlocal
echo. & echo Done! & pause
cls
goto Menu

REM End.
:End
echo Exiting...
endlocal & exit

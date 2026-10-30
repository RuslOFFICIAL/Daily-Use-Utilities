@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Variables.
set "VariablesFileName=Variables.conf"
set "VariablesFile=..\Configs\%VariablesFileName%"
set "CommandsFileName=DUU-Launcher_Info.conf"
set "CommandsFile=..\Configs\%CommandsFileName%"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VariablesFile%'^^! & echo Check if you have that file or download it from the repository^^! & echo.
)

if not exist "%CommandsFile%" (
	echo [ERROR]: File not found at '%CommandsFile%'^^! & echo Check if there is that file or follow the instruction in '%CommandsFile%.example'^^! & echo.
	pause & exit /b 1
)

:Menu
echo DUU-Launcher %DUU_Version% & echo.

set "ValidKeys="
set "FormattedKeys="
set "Count=0"

for /f "usebackq tokens=1,2,3 delims=|" %%A in ("%CommandsFile%") do (
	set "Key=%%A"
	set "Label=%%B"
	set "Script=%%C"
	
	if "!Key:~0,1!" neq "#" if "!Key!" neq "" (
		echo [!Key!] !Label!
		set "Key_!Key!=!Script!"
		set "ValidKeys=!ValidKeys!!Key!"
		if defined FormattedKeys (
			set "FormattedKeys=!FormattedKeys!, !Key!"
		) else (
			set "FormattedKeys=!Key!"
		)
		set /a "Count+=1"
	)
)

if %Count%==0 (
	echo [ERROR]: No options found in '%CommandsFileName%'. & echo.
	pause & exit /b 1
)

echo.
choice /c !ValidKeys! /n /m "Enter your choice (!FormattedKeys!): "
set "ChoiceErrorLevel=%errorlevel%"

set "CurrentCount=0"
for /f "usebackq tokens=1,2,3 delims=|" %%A in ("%CommandsFile%") do (
	set "Key=%%A"
	set "Script=%%C"
	if "!Key:~0,1!" neq "#" if "!Key!" neq "" (
		set /a "CurrentCount+=1"
		if !CurrentCount!==%ChoiceErrorLevel% (
			set "SelectedKey=!Key!"
			set "SelectedScript=!Script!"
		)
	)
)

if /i "!SelectedScript!"=="Exit" goto End

REM Run script.
:RunScript
echo. & echo Running "!SelectedScript!.bat"... & echo.
set "ScriptPath=%~dp0!SelectedScript!.bat"

if exist "%ScriptPath%" (
	call "%ScriptPath%"
	echo. & echo Done^^!
) else (
	echo [ERROR]: Could not find script at '%ScriptPath%'^^!
)

echo. & pause
cls
goto Menu

REM End.
:End
echo Exiting...
endlocal & exit /b 0

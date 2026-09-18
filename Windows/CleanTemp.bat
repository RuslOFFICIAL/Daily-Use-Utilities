@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

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
set "CacheFile=%~dp0CleanTemp_Cache.tmp"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VariablesFile%'! & echo Check if you have that file or download it from GitHub repository! & echo.
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

REM Scan initial stats before deletion.
setlocal disabledelayedexpansion
powershell -NoProfile -Command "$culture = [System.Globalization.CultureInfo]::InvariantCulture; $f = Get-ChildItem -Path $env:TempDir -Recurse -Force -ErrorAction SilentlyContinue; $files = @($f | Where-Object {!$_.PSIsContainer}); $dirs = @($f | Where-Object {$_.PSIsContainer}); $size = ($files | Measure-Object -Property Length -Sum).Sum; if(!$size){$size=0}; $mb = [Math]::Round($size / 1MB, 2); \"InitialMB=$($mb.ToString($culture))\"; \"InitialFiles=$($files.Count)\"; \"InitialDirs=$($dirs.Count)\"" > "%CacheFile%"
endlocal

for /f "tokens=*" %%i in ('type "%CacheFile%"') do set "%%i"
del "%CacheFile%" >nul 2>&1

REM Deletion.
echo Deleting the contents of the folder "%TempDir%"...& echo.

REM Files.
echo Files:
del /q /s "%TempDir%\*"

REM Directories.
echo.& echo Directories:
for /d %%d in ("%TempDir%\*") do (
	echo Deleting directory: %%~nxd
	rd /s /q "%%d" >nul 2>&1
)

REM Scan remaining stats after deletion.
setlocal disabledelayedexpansion
powershell -NoProfile -Command "$culture = [System.Globalization.CultureInfo]::InvariantCulture; $f = Get-ChildItem -Path $env:TempDir -Recurse -Force -ErrorAction SilentlyContinue; $files = @($f | Where-Object {!$_.PSIsContainer}); $dirs = @($f | Where-Object {$_.PSIsContainer}); $size = ($files | Measure-Object -Property Length -Sum).Sum; if(!$size){$size=0}; $mb = [Math]::Round($size / 1MB, 2); \"RemainMB=$($mb.ToString($culture))\"; \"RemainFiles=$($files.Count)\"; \"RemainDirs=$($dirs.Count)\"" > "%CacheFile%"
endlocal

for /f "tokens=*" %%i in ('type "%CacheFile%"') do set "%%i"
del "%CacheFile%" >nul 2>&1

if "%InitialMB%"=="" set "InitialMB=0"
if "%InitialFiles%"=="" set "InitialFiles=0"
if "%InitialDirs%"=="" set "InitialDirs=0"
if "%RemainMB%"=="" set "RemainMB=0"
if "%RemainFiles%"=="" set "RemainFiles=0"
if "%RemainDirs%"=="" set "RemainDirs=0"

REM Calculate actual deleted totals safely.
setlocal disabledelayedexpansion
powershell -NoProfile -Command "$culture = [System.Globalization.CultureInfo]::InvariantCulture; $initMB = [double]::Parse('%InitialMB%', $culture); $remMB = [double]::Parse('%RemainMB%', $culture); $delFiles = [Math]::Max(0, %InitialFiles% - %RemainFiles%); $delDirs = [Math]::Max(0, %InitialDirs% - %RemainDirs%); $delMB = [Math]::Max(0, $initMB - $remMB); \"FileCount=$delFiles\"; \"DirCount=$delDirs\"; \"FreedMB=$delMB\"" > "%CacheFile%"
endlocal

for /f "tokens=*" %%i in ('type "%CacheFile%"') do set "%%i"
del "%CacheFile%" >nul 2>&1

goto End

REM End.
:End
endlocal & set "FileCount=%FileCount%" & set "DirCount=%DirCount%" & set "FreedMB=%FreedMB%"
echo.& echo Done!
echo Files deleted:		%FileCount%
echo Directories removed:	%DirCount%
echo Space freed:		%FreedMB% MB
pause

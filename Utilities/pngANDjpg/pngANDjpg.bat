@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo pngANDjpg %pngANDjpg_Version%& echo.

REM Check if Pillow is installed.
python -c "import PIL" >nul 2>&1
if %errorlevel% NEQ 0 (
	echo Pillow not found. Attempting installation...
	python -m pip install Pillow&echo.
)

:Menu
REM Images convertation choice.
echo 1. PNG to JPG
echo 2. JPG to PNG
set /p choice="Insert your choice (1, 2): "

if "%choice%"=="1" (
	set "ext=png"
	set "target=jpg"
	goto UserInput
) else if "%choice%"=="2" (
	set "ext=jpg"
	set "target=png"
	goto UserInput
) else (
	goto Menu
)

REM User input.
:UserInput
set /p InputDir="Enter source directory with images: "
set /p OutputDir="Enter output directory for converted images: "

REM Check directories.
if "%InputDir%"=="" goto EmptyDir
if not exist "%OutputDir%" (
	echo Creating output directory...
	mkdir "%OutputDir%"
)
goto Convert

REM Convertation.
:Convert
echo Converting ".%ext%" to ".%target%"...

for %%f in ("%InputDir%\*.%ext%") do (
	echo Converting "%%~nxf"...
	python -c "from PIL import Image; import os; im = Image.open(os.path.join(r'%InputDir%', r'%%f')); im.convert('RGB').save(os.path.join(r'%OutputDir%', r'%%~nf.%target%'))"
)
goto End

REM End.
:End
endlocal
echo.& echo Done!
pause
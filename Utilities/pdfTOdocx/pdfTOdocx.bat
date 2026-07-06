@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo pdfTOdocx %pdfTOdocx_Version%&echo.

REM Check if pdf2docx is installed and available in the system PATH.
python -c "import pdf2docx" >nul 2>&1
if %errorlevel% NEQ 0 (
	echo pdf2docx not found. Attempting installation...
	python -m pip install pdf2docx
	
	REM Verify installation again.
	python -c "import pdf2docx" >nul 2>&1
	if %errorlevel% NEQ 0 (
		echo Installation failed or command not found.
		echo Please ensure Python is added to your PATH.
		pause
		exit /b
	)
) else (
	echo pdf2docx has been found.
	goto UserInput
)

REM User input.
:UserInput
set /p InputDir="Enter the source directory with .docx files (e.g. C:\Path\To\pdf\Files): "
set /p OutputDir="Enter the output directory for DOCXs (e.g. C:\Path\To\DOCX\Files): "
goto Check

REM Check.
:Check
if "%InputDir%"=="" goto EmptyDir
if not exist "%OutputDir%" (
	echo Creating output directory...
	mkdir "%OutputDir%"
)
goto Convert

REM Empty directory.
:EmptyDir
echo No valid directory was provided.
goto End

REM Convert.
:Convert
for %%f in ("%InputDir%\*.docx") do (
	echo Processing: %%~nxf
	python -c "from pdf2docx import Converter; cv = Converter(r'%%f'); cv.convert(r'%OutputDir%\%%~nf.docx'); cv.close()"
)
goto End

REM End.
:End
endlocal
echo.& echo Done!
pause

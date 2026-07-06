@echo off
cd /d "%~dp0"
setlocal

REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo docxANDpdf %docxANDpdf_Version%&echo.
goto Choice

REM Choice.
:Choice
echo 1. DOCX to PDF&echo 2. PDF to DOCX
set /p choicev="Insert your choice (1, 2): "
goto UserInput

REM User input.
:UserInput
set /p InputDir="Enter the source directory with input files (e.g. C:\Path\To\Input\Files): "
set /p OutputDir="Enter the output directory for output files (e.g. C:\Path\To\Output\Files): "
goto CheckDir

REM Check directory.
:CheckDir
if "%InputDir%"=="" goto EmptyDir
if not exist "%OutputDir%" (
	echo Creating output directory...
	mkdir "%OutputDir%"
)
goto CheckChoice

REM Empty directory.
:EmptyDir
echo No valid directory was provided.
goto End

REM Check choice.
:CheckChoice
if "%choicev%"=="1" (
	goto docxtopdf
) else if "%choicev%"=="2" (
	goto pdftodocx
) else (
	goto Choice
)



REM docxTOpdf
:docxtopdf

REM Check if docx2pdf is installed and available in the system PATH.
where docx2pdf >nul 2>&1
if %errorlevel% NEQ 0 (
	echo docx2pdf not found in PATH. Attempting installation...
	python -m pip install docx2pdf
	
	REM Verify installation again.
	where docx2pdf >nul 2>&1
	if %errorlevel% NEQ 0 (
		echo Installation failed or command not found.
		echo Please ensure Python is added to your PATH.
		pause
		exit /b
	)
) else (
	echo docx2pdf has been found.
)

REM Convert.
for %%f in ("%InputDir%\*.docx") do (
	echo Processing: %%~nxf
	docx2pdf "%%f" "%OutputDir%\%%~nf.pdf"
)
goto End


REM pdfTOdocx
:pdftodocx

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
)

REM Convert.
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

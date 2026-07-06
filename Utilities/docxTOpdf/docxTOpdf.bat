@echo off
setlocal

REM .conf files.
if exist "..\..\.conf-files\Variables.conf" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("..\..\.conf-files\Variables.conf") do set "%%A=%%~B"
)

echo docxTOpdf %docxTOpdf_Version%&echo.

REM Check if docx2pdf is installed and available in the system PATH.
where docx2pdf >nul 2>&1
if %errorlevel% NEQ 0 (
	echo docx2pdf not found in PATH. Attempting installation...
	python -m pip install docx2pdf
	
	REM Verify installation again.
	where docx2pdf >nul 2>&1
	if %ERRORLEVEL% NEQ 0 (
		echo Installation failed or command not found.
		echo Please ensure Python is added to your PATH.
		pause
		exit /b
	)
) else (
	echo docx2pdf has been found.
	goto UserInput
)

REM User input.
:UserInput
set /p InputDir="Enter the source directory with .docx files (e.g. C:\Path\To\Doxc\Files): "
set /p OutputDir="Enter the output directory for PDFs (e.g. C:\Path\To\PDF\Files): "
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
	python -m docx2pdf "%%f" "%OutputDir%\%%~nf.pdf"
)
goto End

REM End.
:End
endlocal
echo.& echo Done!
pause

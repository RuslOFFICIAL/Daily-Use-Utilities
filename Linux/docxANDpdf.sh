#!/bin/bash
cd "$(dirname "$0")" || exit

# Variables.
VARIABLES_FILE_NAME="Variables.conf"
VARIABLES_FILE="../Configs/$VARIABLES_FILE_NAME"

# Configs.
if [ -f "$VARIABLES_FILE" ]; then
	while IFS='=' read -r key value; do
		[[ "$key" =~ ^#.* ]] || [[ -z "$key" ]] && continue
		clean_value="${value%$'\r'}"
		export "$key=$clean_value"
	done < "$VARIABLES_FILE"
else
	echo "Warning: File not found at '$VARIABLES_FILE'!" && echo "Check if you have that file or download it from GitHub repository!" && echo
fi

echo "docxANDpdf $docxANDpdf_Version" && echo

# Menu Choice.
while true; do
	echo "1. DOCX to PDF" && echo "2. PDF to DOCX"
	read -r -e -p "Insert your choice (1, 2): " choicev
	[[ "$choicev" == "1" || "$choicev" == "2" ]] && break
	echo "Invalid choice, please try again." && echo
done

# User Input.
echo
read -r -e -p "Enter the source directory with input files (e.g. /Path/To/Input-Folder): " InputDir
read -r -e -p "Enter the output directory for output files (e.g. /Path/To/Output-Folder): " OutputDir

# Validate and Prepare Directories.
if [ -z "$InputDir" ] || [ ! -d "$InputDir" ]; then
	echo "Error: Source directory does not exist." && echo
	read -s -p "Press [Enter] to exit..." && exit 1
fi

if [ ! -d "$OutputDir" ]; then
	echo "Creating output directory..."
	mkdir -p "$OutputDir"
fi

# Logic for Conversion.
if [ "$choicev" == "1" ]; then
	# DOCX to PDF.
	if ! command -v docx2pdf &> /dev/null; then
		echo -n "docx2pdf not found. Installing..."
		pip3 install docx2pdf
		echo "Success!"
	fi
	
	for f in "$InputDir"/*.docx; do
		[ -f "$f" ] || continue
		echo "Processing: $(basename "$f")"
		docx2pdf "$f" "$OutputDir/$(basename "${f%.docx}.pdf")"
	done

else
	# PDF to DOCX.
	if ! python3 -c "import pdf2docx" &> /dev/null; then
		echo -n "pdf2docx not found. Installing... "
		pip3 install pdf2docx
		echo "Success!"
	fi

	for f in "$InputDir"/*.pdf; do
		[ -f "$f" ] || continue
		echo "Processing: $(basename "$f")"
		python3 -c "from pdf2docx import Converter; cv = Converter('$f'); cv.convert('$OutputDir/$(basename "${f%.pdf}.docx")'); cv.close()"
	done
fi

# End.
echo && echo "Done!"
read -s -p "Press [Enter] to continue..." && exit 0
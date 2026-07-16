#!/bin/bash
cd "$(dirname "$0")" || exit

# Variables.
VARIABLES_FILE="../../.conf-files/Variables.conf"

# .conf files.
if [ -f "$VARIABLES_FILE" ]; then
	while IFS='=' read -r key value; do
		[[ "$key" =~ ^#.* ]] || [[ -z "$key" ]] && continue
		clean_value="${value%$'\r'}"
		export "$key=$value"
	done < "$VARIABLES_FILE"
fi

echo "pngANDjpg $pngANDjpg_Version" && echo ""

# Menu Selection.
while true; do
	echo "1. PNG to JPG" && echo "2. JPG to PNG"
	read -p "Insert your choice (1, 2): " choice
	case "$choice" in
		1) ext="png"; target="jpg"; break ;;
		2) ext="jpg"; target="png"; break ;;
		*) echo "Invalid choice, please try again."; echo "" ;;
	esac
done

# User Input.
echo ""
read -r -p "Enter source directory with images: " InputDir
read -r -p "Enter output directory for converted images: " OutputDir

# Validate Directories
if [ -z "$InputDir" ] || [ ! -d "$InputDir" ]; then
	echo "Error: Invalid source directory."
	read -s -n 1 -p "Press any key to exit..." && exit 1
fi

if [ ! -d "$OutputDir" ]; then
	echo -n "Creating output directory..."
	mkdir -p "$OutputDir"
	echo "Success!"
fi

# Convert.
echo "" && echo "Converting .$ext to .$target..."
for f in "$InputDir"/*."$ext"; do
	[ -f "$f" ] || continue
	
	export TARGET_FILE="$f"
	export OUTPUT_DIR="$OutputDir"
	export TARGET_EXT="$target"

	filename=$(basename "$f")
	base="${filename%.*}"
	echo "Converting \"$filename\"..."
	
	python3 -c "import os; from PIL import Image; from pathlib import Path; \
	in_path = Path(os.environ['TARGET_FILE']); \
	out_dir = Path(os.environ['OUTPUT_DIR']); \
	im = Image.open(in_path); \
	im.convert('RGB').save(out_dir / f'{os.path.splitext(os.path.basename(os.environ[\"TARGET_FILE\"]))[0]}.{os.environ[\"TARGET_EXT\"]}')"
done

# End.
echo "" && echo "Done!"
read -s -n 1 -p "Press any key to continue..." && exit 0
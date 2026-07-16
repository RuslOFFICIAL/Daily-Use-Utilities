#!/bin/bash
cd "$(dirname "$0")" || exit

# Variables.
VARIABLES_FILE="../.conf-files/Variables.conf"

# .conf files.
if [ -f "$VARIABLES_FILE" ]; then
	while IFS='=' read -r key value; do
		[[ "$key" =~ ^#.* ]] || [[ -z "$key" ]] && continue
		clean_value="${value%$'\r'}"
		export "$key=$value"
	done < "$VARIABLES_FILE"
fi

echo "DUU-Launcher $DUU_Version" && echo ""

# Menu selection
echo "What script would you like to run?"
echo "[1] CleanTemp" && echo "[2] docxANDpdf" && echo "[3] folderTOarchive" && echo "[4] pngANDjpg" && echo "[5] SystemCheck"
echo ""

while true; do
	read -p "Enter your choice (1, 2, 3, 4, 5): " choice
	case $choice in
		1) ScriptName="CleanTemp"; break ;;
		2) ScriptName="docxANDpdf"; break ;;
		3) ScriptName="folderTOarchive"; break ;;
		4) ScriptName="pngANDjpg"; break ;;
		5) ScriptName="SystemCheck"; break ;;
		*) echo "Invalid choice, please try again." ;;
	esac
done

# Execute the target script.
ScriptPath="$ScriptName/$ScriptName.sh"

echo "Running \"$ScriptName.sh\"..." & echo ""

if [ -f "$ScriptPath" ]; then
	bash "$ScriptPath"
	echo "" && echo "" && echo "Done!"
	read -s -n 1 -p "Press any key to continue..." && exit 0	
else
	echo "Error: Script not found at $ScriptPath"
	read -s -n 1 -p "Press any key to continue..." && exit 1
fi

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

echo "Linux-TARGZ $DUU_Version" && echo

# Paths
SOURCE_DIR=".."
STAGING_DIR="../TempReleaseLinux"
CONFIGS_DIR="$STAGING_DIR/Configs"
ZIP_FOLDER="../Releases"
ZIP_FILE="$ZIP_FOLDER/DUU_$DUU_Version-Linux.tar.gz"

echo -n "Cleaning release folder... "
rm -f "$ZIP_FOLDER"/DUU_*-Linux.tar.gz

echo "Done!" && echo -n "Preparing release folder... "
mkdir -p "$STAGING_DIR"

echo "Done!" && echo -n "Copying files... "
shopt -s dotglob
for item in ../*; do
	name=$(basename "$item")
	
	if [[ "$name" == "TempReleaseLinux" || "$name" == "TempReleaseWin" || "$name" == "Releases" || "$name" == ".git" || "$name" == "Configs" || "$name" == "Windows" || "$name" == *.lnk || "$name" == DUU-Windows.bat ]]; then
		continue
	fi

	cp -a "$item" "$STAGING_DIR/"
done
shopt -u dotglob

echo "Done!" && echo -n "Including '$VARIABLES_FILE_NAME' in release... "
mkdir -p "$CONFIGS_DIR"
cp "$VARIABLES_FILE" "$CONFIGS_DIR"

# Make files to be executable.
if [ -n "$Executable" ]; then
	echo "Done!" && echo -n "Applying executable permissions... "
	
	(cd "$STAGING_DIR" && chmod $Executable 2>/dev/null)
fi

echo "Done!" && echo -n "Compressing into .tar.gz file... "
mkdir -p "$ZIP_FOLDER"
tar -czf "$ZIP_FILE" -C "$STAGING_DIR" .

echo "Done!" && echo -n "Cleaning up temporary folders... "
rm -rf "$STAGING_DIR"

echo "Done!" && echo && echo "Done!"
echo "Your release is ready inside the 'Releases' folder."
read -s -p "Press [Enter] to continue..." && exit 0
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

echo "folderTOarchive $folderTOarchive_Version" && echo ""

# User Input
read -r -p "Enter the directory path to archive (e.g. /Path/To/Folder): " SourceDir
read -r -p "Enter the destination .TAR.GZ path (e.g. /Path/To/File.tar.gz): " ArchivePath

# Check and Clean.
if [ -z "$SourceDir" ] || [ -z "$ArchivePath" ]; then
	echo "No valid directory or output path was provided."
	read -s -n 1 -p "Press any key to exit..." && exit 1
fi

if [ -f "$ArchivePath" ]; then
	echo "Removing existing file..."
	rm -f "$ArchivePath"
	if [ -f "$ArchivePath" ]; then
		echo "[ERROR] Could not delete existing archive. Please check permissions."
		read -s -n 1 -p "Press any key to exit..." && exit 1
	fi
fi

# Compress.
echo "Compressing files..."
if tar -czvf "$ArchivePath" -C "$(dirname "$SourceDir")" "$(basename "$SourceDir")"; then
	echo && echo "Success! Created: $ArchivePath"
else
	echo "" && echo "[ERROR] An error occurred during compression."
fi

# End.
echo && echo "Done!"
read -s -n 1 -p "Press any key to continue..." && exit 0
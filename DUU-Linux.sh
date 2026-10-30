#!/bin/bash
set +H
cd "$(dirname "$0")" || exit

# Define the file path.
FILE_PATH="./DUU-Launcher_Linux.sh"
DIRECTORY_NAME="Linux"

cd "$DIRECTORY_NAME" || { echo -e "Directory '$DIRECTORY_NAME' not found.\n"; read -s -n 1 -p "Press any key to continue..."; exit 1; }

if [ -f "$FILE_PATH" ]; then
	echo "Processing file: '$(basename "$FILE_PATH")'..."
	if xattr -p com.apple.metadata:kMDItemWhereFroms "$FILE_PATH" >/dev/null 2>&1 || \
	xattr -p com.apple.quarantine "$FILE_PATH" >/dev/null 2>&1; then
		xattr -d com.apple.quarantine "$FILE_PATH" 2>/dev/null
		echo "File unblocked."
	else
		echo "File not blocked."
	fi
	echo && "$FILE_PATH"
else
	echo "File not found: '$FILE_PATH'"
	read -s -p "Press [Enter] to continue..." && exit 1
fi

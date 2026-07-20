#!/bin/bash
cd "$(dirname "$0")" || exit

# Admin check.
if [ "$EUID" -ne 0 ]; then
	echo "Failure: This script must be run as an Administrator (sudo)."
	read -s -p "Press [Enter] to continue..." && exit 1
fi

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

echo "CleanTemp $CleanTemp_Version" && echo

# Confirmation.
while true; do
	read -p "Are you sure you want to run this script? (Y/n) " confirmation
	case "$confirmation" in
		[Yy]* ) break ;;
		[Nn]* ) echo "Operation cancelled by user."; read -s -p "Press [Enter] to continue..."; exit 0 ;;
		* ) echo "Please answer Y or n." ;;
	esac
done

# Deletion.
TEMP_DIR="/tmp"

echo "Deleting the contents of the folder \"$TEMP_DIR\"..."

# Delete files and directories.
find "$TEMP_DIR" -mindepth 1 -delete

# End.
echo && echo "Done!"
read -s -p "Press [Enter] to continue..." && exit 0
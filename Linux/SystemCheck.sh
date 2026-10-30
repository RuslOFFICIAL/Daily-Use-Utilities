#!/bin/bash
cd "$(dirname "$0")" || exit

# Admin check.
if [ "$EUID" -ne 0 ]; then
	echo "Failure: This script must be run as an Administrator (sudo)."
	read -s -p "Press [Enter] to continue..." && exit 1
fi

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
	echo "Warning: File not found at '$VARIABLES_FILE'!" && echo "Check if you have that file or download it from the repository!\n"
fi

echo -e "SystemCheck $SystemCheck_Version"

# Confirmation.
while true; do
	read -r -e -p "Are you sure you want to run this script? (Y/N) " confirmation
	case "$confirmation" in
		[Yy]* ) echo; break ;;
		[Nn]* ) echo -e "\nOperation cancelled by user.\n"; read -s -p "Press [Enter] to continue..."; exit 0 ;;
		* ) echo -e "Please answer Y or n.\n" ;;
	esac
done

# Integrity Checks.
echo "Running system integrity checks..."

# Debian/Ubuntu systems.
if command -v apt &> /dev/null; then
	echo "Updating package lists..."
	apt update
	
	echo "Verifying installed packages (debsums)..."
	if command -v debsums &> /dev/null; then
		debsums -c 
	else
		echo "Please install 'debsums' to run integrity verification."
	fi

# Arch-based systems.
elif command -v pacman &> /dev/null; then
	echo "Checking package integrity..."
	pacman -Qkk
fi

# End.
echo -e "\nDone!"
read -s -p "Press [Enter] to continue..." && exit 0

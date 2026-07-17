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

echo "SystemCheck $SystemCheck_Version" && echo ""

# Confirmation.
while true; do
	read -p "Are you sure you want to run this script? (Y/n) " confirmation
	case "$confirmation" in
		[Yy]* ) break ;;
		[Nn]* ) echo "Operation cancelled by user."; read -s -p "Press [Enter] to continue..."; exit 0 ;;
		* ) echo "Please answer Y or n." ;;
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
echo "" && echo "Done!"
read -s -p "Press [Enter] to continue..." && exit 0
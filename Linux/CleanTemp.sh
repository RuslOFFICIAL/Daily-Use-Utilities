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
	echo "Warning: File not found at '$VARIABLES_FILE'!" && echo "Check if you have that file or download it from GitHub repository!" && echo
fi

echo "CleanTemp $CleanTemp_Version" && echo

# Confirmation.
while true; do
	read -r -e -p "Are you sure you want to run this script? (Y/n) " confirmation
	case "$confirmation" in
		[Yy]* ) echo; break ;;
		[Nn]* ) echo; echo "Operation cancelled by user."; echo; read -s -p "Press [Enter] to continue..."; exit 0 ;;
		* ) echo "Please answer Y or n."; echo ;;
	esac
done

# Deletion.
TEMP_DIR="/tmp"
echo "Deleting the contents of the folder \"$TEMP_DIR\"..." && echo

# Scan initial stats before deletion.
initial_bytes=0
initial_files=0
initial_dirs=0
if [ -d "$TEMP_DIR" ]; then
	initial_bytes=$(du -sb "$TEMP_DIR" 2>/dev/null | awk '{print $1}')
	[ -z "$initial_bytes" ] && initial_bytes=$(( $(du -sk "$TEMP_DIR" 2>/dev/null | awk '{print $1}') * 1024 ))
	initial_files=$(find "$TEMP_DIR" -mindepth 1 -type f 2>/dev/null | wc -l)
	initial_dirs=$(find "$TEMP_DIR" -mindepth 1 -type d 2>/dev/null | wc -l)
fi

# Delete files and directories.
find "$TEMP_DIR" -mindepth 1 -delete

# Scan remaining stats after deletion.
remain_bytes=0
remain_files=0
remain_dirs=0
if [ -d "$TEMP_DIR" ]; then
	remain_bytes=$(du -sb "$TEMP_DIR" 2>/dev/null | awk '{print $1}')
	[ -z "$remain_bytes" ] && remain_bytes=$(( $(du -sk "$TEMP_DIR" 2>/dev/null | awk '{print $1}') * 1024 ))
	remain_files=$(find "$TEMP_DIR" -mindepth 1 -type f 2>/dev/null | wc -l)
	remain_dirs=$(find "$TEMP_DIR" -mindepth 1 -type d 2>/dev/null | wc -l)
fi

# Calculate actual deleted totals safely.
file_count=$((initial_files - remain_files))
[ "$file_count" -lt 0 ] && file_count=0

dir_count=$((initial_dirs - remain_dirs))
[ "$dir_count" -lt 0 ] && dir_count=0

freed_bytes=$((initial_bytes - remain_bytes))
[ "$freed_bytes" -lt 0 ] && freed_bytes=0
freed_mb=$(awk -v bytes="$freed_bytes" 'BEGIN {printf "%.2f", bytes / 1024 / 1024}')

# End.
echo && echo "Done!"
echo "Files deleted:	$file_count"
echo "Directories removed:	$dir_count"
echo "Space freed:	$freed_mb MB"
read -s -p "Press [Enter] to continue..." && exit 0
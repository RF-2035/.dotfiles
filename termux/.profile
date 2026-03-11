dialogSelect() {
	dialog --title "$1" --menu "$2" 15 50 5 "${@:3}" 2>&1 >/dev/tty
}

# --------------------------------------

while true; do
	options=()
	declare -A file_map
	i=1

	while IFS= read -r -d '' file; do
		filename=$(basename "$file")
		options+=("$i" "$filename") # Add tag and item as separate array elements
		file_map[$i]="$file"        # Store the full path for execution later
		((i++))
	done < <(find "$HOME/.local/bin" -maxdepth 1 -type f -executable -print0)

	if [ ${#options[@]} -eq 0 ]; then
		clear
		echo "No executable scripts found in $HOME/.local/bin."
		break
	fi

	CHOICE=$(dialogSelect "Termux" "Choose a Script:" "${options[@]}")

	if [ -n "$CHOICE" ]; then
		clear
		"${file_map[$CHOICE]}"
		read -p "Press Enter to return to the menu..."
	else
		clear
		echo "Welcome to Termux!"
		break
	fi
done

dialogSelect() {
	dialog --title "$1" --extra-button --extra-label "$2" --menu "$3" 15 50 5 "${@:4}" 2>&1 >/dev/tty
}

dialogMsg() {
	dialog --title "$1" --msgbox "$2" 8 50
}

dialogChangeDir() {
	dialog --title "$1" --dselect "$PWD/" 15 50 2>&1 >/dev/tty
}

# --------------------------------------

# ┌──────────┐
# │ XDG Home │
# └──────────┘

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export PATH="$HOME/.local/bin:$PATH"

# ┌──────────┐
# │ Services │
# └──────────┘

INIT_DIR="${XDG_DATA_HOME}/init.d"

if [ -d "$INIT_DIR" ]; then
	for script in "$INIT_DIR"/*; do
		if [ -f "$script" ] && [ -x "$script" ]; then
			. "$script" start >/dev/null 2>&1
		fi
	done
fi

# ┌───────────┐
# │ Main Menu │
# └───────────┘

while true; do
	options=()
	declare -A file_map
	i=1

	while IFS= read -r -d '' file; do
		filename=$(basename "$file")
		options+=("$i" "$filename") # Add tag and item as separate array elements
		file_map[$i]="$file"        # Store the full path for execution later
		((i++))
	done < <(find -L "$HOME/.local/bin" -maxdepth 1 -type f -executable -print0)

	clear

	CHOICE=$(dialogSelect "Termux" "CD..." "${PWD}:" "${options[@]}")
	DIALOG_EXIT_CODE=$?

	clear

	case $DIALOG_EXIT_CODE in
	0)
		if [ -n "$CHOICE" ]; then
			"${file_map[$CHOICE]}"
			read -p "Press Enter to return to the menu..."
		fi
		;;
	3)
		NEW_DIR=$(dialogChangeDir "Select Directory")
		DSELECT_EXIT_CODE=$?
		if [ $DSELECT_EXIT_CODE -eq 0 ] && [ -n "$NEW_DIR" ] && [ -d "$NEW_DIR" ]; then
			cd "$NEW_DIR" || dialogMsg "Failed to change directory."
			if [ -x "${XDG_DATA_HOME}/init.d/lastd" ]; then
				"${XDG_DATA_HOME}/init.d/lastd" save "$NEW_DIR" >/dev/null 2>&1
			fi
		fi
		;;
	*)
		echo "Welcome to Termux!"
		break
		;;
	esac
done

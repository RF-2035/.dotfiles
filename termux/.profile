nds() {
	[ "${NNNLVL:-0}" -eq 0 ] || {
		echo "nnn is already running"
		return
	}
	export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
	command nnn "$@"
	NNN_RETURN_DIR=""
	[ ! -f "$NNN_TMPFILE" ] || {
		. "$NNN_TMPFILE"
		NNN_RETURN_DIR="$PWD"
		rm -f -- "$NNN_TMPFILE" >/dev/null
	}
}

dialogSelect() {
	dialog --title "$1" --extra-button --extra-label "$2" --menu "$3" 15 50 5 "${@:4}" 2>&1 >/dev/tty
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

	CHOICE=$(dialogSelect "Termux" "Change Dir..." "${PWD}:" "${options[@]}")
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
		nds
		if [ -n "$NNN_RETURN_DIR" ]; then
			${XDG_DATA_HOME}/init.d/lastd save "$NNN_RETURN_DIR" >/dev/null
		fi
		;;
	*)
		echo "Welcome to Termux!"
		break
		;;
	esac
done

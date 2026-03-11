dialogSelect() {
	dialog --title "$1" --menu "$2" 15 50 5 "${@:3}" 2>&1 >/dev/tty
}

# --------------------------------------

while true; do
	FILE=$(dialogSelect "Termux" "Choose a Script:" $(find $HOME/.local/bin -maxdepth 1 -type f -executable -printf "%f\n" | awk '{print NR " " $0}'))

	if [ -n "$FILE" ]; then
		FILE=$(ls $HOME/.local/bin | awk "NR==$FILE {print \$0}")
		$HOME/.local/bin/$FILE
	else
		clear
		echo "Welcome to Termux!"
		break
	fi
done

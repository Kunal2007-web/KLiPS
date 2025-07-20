#!/usr/bin/env bash

source ../../klips_env

run_fzf() {
    local FILE="$1"
    local APP_TYPE="$2"
    cat "$FILE" | fzf -e --delimiter=" " --multi --reverse --header="Choose $APP_TYPE to Install Using <Tab> Key and Confirm with <Enter> Key:" --header-border=bold >> ../../install.list
}

while true; do
	if [[ -f "../../install.list" ]]; then
		printf "Selected Packages:\n"
		cat ../../install.list 2>/dev/null | cut -d " " -f 1 | column -c 120
	fi
	printf "\nChoose Categories:\n"
	echo " 1. Browsers"
	echo " 2. CLI Apps"
	echo " 3. Code/Text Editors"
	echo " 4. Terminal Commands"
	echo " 5. Multimedia Apps"
	echo " 6. Office Apps"
	echo " 7. Programming Languages"
	echo " 8. Terminal Apps"
	echo " 9. Utilities"
	echo "10. Miscellaneous Apps"
	echo " i. Install"
	echo " r. Restart"
	echo " s. Save and Quit"
	echo " q. Quit, Don't Save"
	read -p "[1..10/i/s/q]> " CAT_CHOICE

	case $CAT_CHOICE in
		"1")
			run_fzf "./browsers.list" "Browsers"
			;;
		"2")
			run_fzf "./cli-tui.list" "CLI/TUI Apps"
			;;
		"3")
			run_fzf "./code-text-editors.list" "Code/Text Editors"
			;;
		"4")
			run_fzf "./commands.list" "Terminal Commands"
			;;
		"5")
			run_fzf "./multimedia.list" "Multimedia Apps"
			;;
		"6")
			run_fzf "./office-apps.list" "Office Apps"
			;;
		"7")
			run_fzf "./programming.list" "Programming Languages"
			;;
		"8")
			run_fzf "./terminals.list" "Terminal Apps"
			;;
		"9")
			run_fzf "./utilties.list" "Utility Apps"
			;;
		"10")
			run_fzf "./miscellaneous.list" "Miscellaneous Apps"
			;;
		"i"|"I")
			printf "The following programs will be installed:\n"
			cat ../../install.list 2>/dev/null | cut -d " " -f 1 | column -c 120
			read -p "\nDo you want to continue with the installation?[Y/n]: " CONFIRM_CHOICE

			case $CONFIRM_CHOICE in
				"Y"|"y"|"")
					echo "Continuing With Installation..."
					cd $KLIPS_DIR
					exit 0
					;;
				"N"|"n")
					echo "Cancelling..."
					;;
				*)
					echo "Invalid Option: Cancelling..."
					;;
			esac
			;;
		"r"|"R")
			echo "Restarting..."
			rm ../../install.list
			;;
		"s"|"S")
			if [[ -f "../../install.list" ]]; then
				echo "Selected Packages are Saved in install.list . It is reusable with install-apps.sh script"
			fi
			cd $KLIPS_DIR
			exit 1
			;;
		"q"|"Q")
			echo "Quitting..."
			exit 2
			;;
		*)
    	    printf "\nInvalid Option!"
	        ;;
	esac
done

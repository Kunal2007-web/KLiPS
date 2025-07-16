#!/usr/bin/env bash

# ENV File
source ./klips_env

# Functions
# Checks OS
detect_os_installation() {
	case $DISTRO in
		"Arch")
			echo "Arch/Arch-Based Linux Distribution Detected!"
			check_requirements "paru" "flatpak" "brew" "fzf"
			cd $KLIPS_DIR/scripts/arch
			sh archibald.sh
			;;
		*)
			choose_os
			;;
	esac
}

# Prompts the user to choose what type of distribution is in use, if it can't be categorized automatically.
choose_os() {
	echo "Detected Distribution Couldn't Be Categorized. Please Choose:"
	echo "What type of distro are you using?"
	echo "1. Arch or Arch-Based"
	echo "2. Debian or Debian-Based (No PPAs)"
	echo "3. Ubuntu or Ubuntu-Based (PPAs)"
	echo "4. Fedora or Fedora-Based"
	echo "5. OpenSUSE or OpenSUSE-Based"
	echo "6. Void or Void-Based"
	echo "7. Gentoo or Gentoo-Based"
	echo "8. Quit and Cancel"
	read -rp "Choose: " DISTRO_CHOICE

	case $DISTRO_CHOICE in
		1)DISTRO="Arch";;
		2)DISTRO="Debian";;
		3)DISTRO="Ubuntu";;
		4)DISTRO="Fedora";;
		5)DISTRO="OpenSUSE";;
		6)DISTRO="Void";;
		7)DISTRO="Gentoo";;
		8)
		echo "Goodbye!"
		exit
		;;
		*)
		echo "Invalid Option!"
		exit
		;;
	esac

	echo "Restarting With Your Choice..."
	detect_os_installation
}

# Check if requirmeents for the specific distribution are installed.
check_requirements() {
	echo "Checking Requirements..."
	for i in $@; do
		if ! [ "$(command -v "$i")" ]; then
			echo "$i not installed. Install it and then run the script."
			exit 1
		fi
	done
}

# Execution
echo "Welcome to Kunal's Linux Post-installation Script (KLiPS)!"
echo "Detecting Linux Distribution..."
detect_os_installation
if [[ $? == 1 ]]; then
	exit
elif [[ $? == 2 ]]; then
	rm $KLIPS_DIR/install.list
	exit
fi
cd $KLIPS_DIR/scripts
sh install-apps.sh ../install.list
cd $KLIPS_DIR
echo "Thank You for Using KLiPS!"
echo "If you used faced any errors or issues, please report it on our Github."
echo "If it is a security related issue, please send me a email at kunalkumarchourasiya2021@gmail.com"

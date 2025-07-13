#!/usr/bin/env bash

if ! [[ -f "$1" && "${1##*.}" == "list" ]]; then
	echo "Invalid Argument! Exiting..."
	exit
fi

source ../klips_env

INS_CMD=

case $DISTRO in
	"Arch")
		INS_CMD="paru -S --noconfirm"
		archibald
		;;
	*)
		echo "Distribution Not Supported! Exiting..."
		exit
		;;
esac

archibald() {
	SEL_LST="$(cat ../install.list)"
	readarray -t PAC_LST < <(echo "$SEL_LST" | cut -d " " -f 2)
    readarray -t TYPE_LST < <(echo "$SEL_LST" | cut -d " " -f 3)

	NATIVE_LST=""
	FLATPAK_LST=""
	HOMEBREW_LST=""

	for i in "${!TYPE_LST[@]}"; do
		case "${TYPE_LST[$i]}" in
			"native")NATIVE_LST+="${PAC_LST[$i]} ";;
			"flatpak")FLATPAK_LST+="${PAC_LST[$i]} ";;
			"homebrew")HOMEBREW_LST+="${PAC_LST[$i]} ";;
		esac
	done

	printf "Installing Native Packages...\n"
	$INS_CMD $NATIVE_LST
	printf "\nInstalling Flatpaks...\n"
	flatpak install flathub $FLATPAK_LST
	printf "\nInstalling Homebrew Packages...\n"
	brew install $HOMEBREW_LST

}


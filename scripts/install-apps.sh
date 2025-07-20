#!/usr/bin/env bash

if ! [[ -f "$1" && "${1##*.}" == "list" ]]; then
	echo "Invalid Argument! Exiting..."
	exit
fi

source ../klips_env

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
	if [ -n "$NATIVE_LST" ]; then
		$INS_CMD $NATIVE_LST
	else
		echo "No Native Packages Selected."
	fi
	printf "\nInstalling Flatpaks...\n"
	if [ -n "$FLATPAK_LST" ]; then
		flatpak install flathub $FLATPAK_LST
	else
		echo "No Flatpak Packages Selected."
	fi
	printf "\nInstalling Homebrew Packages...\n"
	if [ -n "$HOMEBREW_LST" ]; then
		brew install $HOMEBREW_LST
	else
		echo "No Homebrew Packages Selected."
	fi

}

INS_CMD=
case $DISTRO in
	"Arch")
		INS_CMD="paru -S"
		archibald
		;;
	*)
		echo "Distribution Not Supported! Exiting..."
		exit
		;;
esac

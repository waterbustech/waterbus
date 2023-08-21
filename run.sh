#!/bin/bash

# Text formatting
BOLD=$(tput bold)
ITALIC=$(tput sitm)
NORMAL=$(tput sgr0)
UNDERLINE=$(tput smul)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

echo "${BOLD}${CYAN}Select an option:${NORMAL}"
echo "1. Run mode: ${GREEN}${ITALIC}DEBUG${NORMAL}"
echo "2. Run mode: ${GREEN}${ITALIC}PROFILE${NORMAL}"
echo "3. Run mode: ${GREEN}${ITALIC}RELEASE${NORMAL}"
while :
do 
	read -p "Run with: " input
	case $input in
		1)
		flutter run --dart-define="waterbus=DEV"
		break
		;;
		2)
		flutter run --dart-define="waterbus=DEV" --profile
		break
		;;
        3)
		flutter run --dart-define="waterbus=DEV" --release
		break
		;;
		*)
		;;
	esac
done
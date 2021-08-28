## Menu
menu() {
	{ clear; banner; banner_small; }
	
	cat <<- EOF
	${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]${ORANGE}
	${RED}[${WHITE}::${RED}]${ORANGE}                          Select Category                          ${RED}[${WHITE}::${RED}]${ORANGE}
	${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]${ORANGE}

	EOF

	menu=($(ls -l .menu | grep '^d' | awk '{ print $9 }'))
	for index in "${!menu[@]}"
	do
		echo " ${RED}[${WHITE}${index}${RED}]${BLUE} ${menu[$index]}"
	done
	
	echo ""
	echo " ${RED}[${WHITE}Aa${RED}]${ORANGE} About"   
	echo " ${RED}[${WHITE}Ee${RED}]${ORANGE} Exit"             
	echo ""

	## Read User Input
	read -p " ${RED}[${WHITE}->${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" = "A" || "$REPLY" = "a" ]]; then
		about
	fi
	if [[ "$REPLY" = "E" || "$REPLY" = "e" ]]; then
		msg_exit
	fi

	c=${#menu[@]}-1
	if [[ $REPLY -le $c ]]; then
		site_menu "${menu[$REPLY]}"
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; menu; }	
	fi
}

## Site Menu
site_menu() {
	{ clear; banner; banner_small; }

	cat <<- EOF
	${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]${ORANGE}
	${RED}[${WHITE}::${RED}]${ORANGE}                        Select Site                                ${RED}[${WHITE}::${RED}]${ORANGE}
	${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]${ORANGE}

	${WHITE} -- ${RED}$1

	EOF
	
	sub_menu=($(ls -l .menu/"$1" | grep '^d' | awk '{ print $9 }'))
	
	for index in "${!sub_menu[@]}"
	do
		echo " ${RED}[${WHITE}${index}${RED}]${BLUE} ${sub_menu[$index]}"
	done

	echo ""
	echo " ${RED}[${WHITE}Mm${RED}]${ORANGE} Back to Main Menu"
	echo " ${RED}[${WHITE}Ee${RED}]${ORANGE} Exit"
	echo ""

	## Read User Input
	read -p " ${RED}[${WHITE}->${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" = "M" || "$REPLY" = "m" ]]; then
		menu
	fi
	if [[ "$REPLY" = "E" || "$REPLY" = "e" ]]; then
		msg_exit
	fi

	c=${#sub_menu[@]}-1
	if [[ $REPLY -le $c ]]; then
		source .menu/"$1"/"${sub_menu[$REPLY]}"/site_"${sub_menu[$REPLY]}".inc
		site_"${sub_menu[$REPLY]}"
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; site_menu; }	
	fi
}
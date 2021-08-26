## About
about() {
	{ clear; banner; banner_small; echo; }
	cat <<- EOF
		
		${GREEN}       Author   ${RED}:  ${ORANGE}Punkin Tech
		${GREEN}       Github   ${RED}:  ${CYAN}https://github.com/punkintech
		${GREEN}       Social   ${RED}:  ${CYAN}https://linktr.ee/PunkinTech
		${GREEN}       Version  ${RED}:  ${ORANGE}v0.1

		${GREEN}       ${ORANGE}:: CREDIT ::
		${GREEN}       Author   ${RED}:  ${ORANGE}TAHMID RAYAT ${RED}[ ${ORANGE}HTR-TECH ${RED}]
		${GREEN}       Github   ${RED}:  ${CYAN}https://github.com/htr-tech
		${GREEN}       Social   ${RED}:  ${CYAN}https://linktr.ee/tahmid.rayat
		${WHITE}       Thanks : Adi1090x,MoisesTapia,ThelinuxChoice 
		                DarkSecDevelopers,Mustakim Ahmed

		${RED}[${WHITE}Mm${RED}]${ORANGE} Main Menu   ${RED}[${WHITE}Ee${RED}]${ORANGE} Exit

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == "E" || "$REPLY" == "e" ]]; then
		msg_exit
	elif [[ "$REPLY" == "M" || "$REPLY" == "m" ]]; then
		echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main menu..."
		{ sleep 1; main_menu; }
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; about; }
	fi
}
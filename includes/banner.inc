##
## Edit banners here
##

## Banner
banner() {
	cat <<- EOF
${ORANGE}      _____                 _     _         _______             _
${ORANGE}     |  __ \               | |   (_)       |__   __|           | |
${ORANGE}     | |__) | _   _  _ __  | | __ _  _ __     | |    ___   ___ | |__
${ORANGE}     |  ___/ | | | || |_ \ | |/ /| || |_ \    | |   / _ \ / __|| |_ \\
${ORANGE}     | |     | |_| || | | ||   < | || | | |   | |  |  __/| (__ | | | |
${ORANGE}     |_|      \__|_||_| |_||_|\_\|_||_| |_|   |_|   \___| \___||_| |_|
${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]
${RED}[${WHITE}::${RED}]${BLUE}                     EDUCATION IN ACTION                           ${RED}[${WHITE}::${RED}]
${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]
${RED}[${WHITE}::${RED}]${WHITE}             STRICTLY FOR EDUCATIONAL USE ONLY                     ${RED}[${WHITE}::${RED}]
${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]      
${GREEN}[${WHITE}::${GREEN}]${CYAN} Based on zPhisher - created by htr-tech (tahmid.rayat)${WHITE}            ${GREEN}[${WHITE}::${GREEN}]
	EOF
}

## Small Banner
banner_small() {
	cat <<- EOF
${BLUE}    _                           ______  _     _      _                 
${BLUE}   | |                         (_____ \| |   (_)    | |                
${BLUE}    \ \  ____   ____ ____  ____ _____) | | _  _  ___| | _   ____  ____ 
${BLUE}     \ \|  _ \ / _  / _  |/ ___|  ____/| || \| |/___| || \ / _  )/ ___)
${BLUE} _____) | | | ( (/ ( ( | | |   | |     | | | | |___ | | | ( (/ /| |    
${BLUE}(______/| ||_/ \____\_||_|_|   |_|     |_| |_|_(___/|_| |_|\____|_| ${WHITE} v0.1   
${BLUE}        |_|                                                            
	EOF
}

## Exit message
msg_exit() {
	{ clear; banner; echo; }
	cat <<- EOF 
${GREENBG}${BLACK}
-------------------------------------------------------------------
               Thank you for using SpearPhisher.                   
-------------------------------------------------------------------
${RESETBG}
	EOF
	{ reset_color; exit 0; }
}
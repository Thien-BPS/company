#!/bin/bash
NORMAL=$(echo "\033[m")
MENU=$(echo "\033[36m") #Blue
NUMBER=$(echo "\033[33m") #yellow
FGRED=$(echo "\033[41m")
RED_TEXT=$(echo "\033[31m")
GRAY_TEXT=$(echo "\033[1;30m")
GREEN_TEXT=$(echo "\033[1;32m")
ENTER_LINE=$(echo "\033[33m")
function ver_info() {
	local param=$1
	local cros=$2
	if [[ "$param" == "ver" ]]; then
		if [[ "$osKernel" == "Linux" ]]; then
			echo -ne $(cat /etc/os-release | grep VERSION= | sed 's/.$//; s/^VERSION="//'^C)
		elif [[ "$osKernel" == "Darwin" ]]; then
			echo -ne $(sw_vers | grep ProductVer | sed 's/^ProductVersion://' | tr -d ' ' | tr -d '[:blank:]')
		elif [[ "$osKernel" == "Linux" && $cros == 1 ]]; then
			echo -ne $(cat /etc/lsb-release | grep CHROMEOS_RELEASE_VERSION | sed 's/^CHROMEOS_RELEASE_VERSION=//')
		fi
	elif [[ "$param" == "script_ver" ]]; then
		echo -ne "${currVer}"
	elif [[ "$param" == "script_date" ]]; then
		echo -ne "${currVerDate}"
	elif [[ "$param" == "board_ver" && $cros == 1]]; then
		echo -ne "${device}"
	elif [[ "$param" == "fw_info" && $cros == 1 && "$isChromeOS" == true ]]; then
		echo -ne "$(sudo crossystem fwid || cut -d"." -f1)"
	fi
}
function cleanup() {
	info "Cleaning up mountpoints..."
	debug "Unmounting: ${mountPoints[@]}, ${loopPoints[@]}"
	for i in ${mountPoints[@]}; do
		umount --detach-loop $i
	done
}
function cleanup_dirty() {

}
function menu_header() {
    printf "\ec"
    clear
	echo -e "${NORMAL}\n Thien's OS debugging utility ${script_date} ${NORMAL}"
	echo -e "${MENU}*********************************************************${NORMAL}"
	echo -e "${MENU}**${NUMBER}		OS: ${NORMAL}$(ver_info "ver") (Running on ${osKernel} kernel)"
	if [[ $isChromeOS == true ]]; then
		echo -e "${MENU}**${NUMBER}		CrOS Platform: ${NORMAL}$(ver_info "board_ver" 1)"
		echo -e "${MENU}**${NUMBER}  	CrOS FW Info: ${NORMAL}$(ver_info "fw_info" 1)"
	fi
	echo -e "${MENU}**${NUMBER}  	Script Version: ${NORMAL}$(ver_info "script_ver") (date: $(ver_info "script_date"))"
	if [[ $isChromeOS == true ]]; then
		if [ "$(crossystem wpsw_cur?1)" = true ]; then
			echo -e "${MENU}**${NUMBER}    CrOS FW WP: ${RED_TEXT}Enabled${NORMAL}"
			WP_TEXT=${RED_TEXT}
			wpEnabled=true
		else
			echo -e "${MENU}**${NUMBER}    CrOS FW WP: ${NORMAL}Disabled"
			WP_TEXT=${GREEN_TEXT}
			wpEnabled=false
		fi
	fi
	echo -e "${MENU}*********************************************************${NORMAL}"
}
function main_menu() {

	menu_header

	if [[ "$unlockMenu" = true || ( "$isChromeOS" == true ) ]]; then
		echo -e "${MENU}**${WP_TEXT}     ${NUMBER} 1)${MENU} Reset Chrome/Chromium OS to Stock (includes firmware) ${NORMAL}"
	else
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 1)${GRAY_TEXT} Reset Chrome/Chromium OS to Stock (includes firmware) ${NORMAL}"
	fi

	if [[ "$unlockMenu" = true || ( "$isChromeOS" == true ) ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 2)${MENU} Reset the ChromeOS firmware to stock ${NORMAL}"
	else
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 2)${GRAY_TEXT} Reset the ChromeOS firmware to stock ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || "$osKernel" == "Darwin" ]]; then
		echo -e "${MENU}**     ${NUMBER} 3)${MENU} Reset macOS to Stock (excludes firmware) ${NORMAL}"
	else
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 3)${GRAY_TEXT} Reset macOS to Stock (excludes firmware) ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || ( "$isChromeOS" == true ) ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 5)${MENU} Remove ChromeOS Forced Enrollment ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || ( "$osKernel" == "Darwin" ) ]]; then
		echo -e "${MENU}**    ${NUMBER} 6)${MENU} Remove macOS Forced Enrollment ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true && "$isChromeOS" == true ]]; then
		echo -e "${MENU}**    ${NUMBER} 7)${MENU} Install sh1mmer & fakemurk on chromeOS ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true && "$isChromeOS" == true ]]; then
		echo -e "${MENU}**    ${NUMBER} 8)${MENU} Reset Chrome/Chromium OS via Powerwashing ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || "$verbose" == false ]]; then
		echo -e "${MENU}**     ${NUMBER} V)${MENU} Enable Verbosity Mode for $0 ${NORMAL}"
	fi
	echo -e "${MENU}*********************************************************${NORMAL}"
	echo -e "${ENTER_LINE}Select a menu option or${NORMAL}"
	echo -e "${nvram}${RED_TEXT}R${NORMAL} to reboot ${NORMAL} ${RED_TEXT}P${NORMAL} to poweroff ${NORMAL} ${RED_TEXT}Q${NORMAL} to quit ${NORMAL}"
	
	read -e opt
	case $opt in

		1)  if [[ "$unlockMenu" == true || ("$isChromeOS" == true )]]; then
				cros_restore
			fi
			main_menu
			;;

		2)  if [[  "$unlockMenu" == true || "$isChromeOS" == true]]; then
				cros_restore_fw
			fi
			main_menu
			;;

		3)  if [[ "$unlockMenu" == true || "$osKernel" == "Darwin" ]]; then
				mac_restore
			fi
			main_menu
			;;

		4)  #if [[ "$unlockMenu" = true || "$isChromeOS" = true || "$isUnsupported" = false \
			#		&& "$isFullRom" = false && "$isBootStub" = false ]]; then
			#	set_hwid
			#fi
			info "This currently does nothing."
			sleep 5
			main_menu
			;;

		5)  if [[ "$unlockMenu" == true || ( "$isChromeOS" == true )  ]]; then
				cros_disable_fc_enrl
			fi
			main_menu
			;;

		6)  #if [[ "$unlockMenu" = true || ( "$isFullRom" = false && "$isBootStub" = false && \
			#		( "$isHsw" = true || "$isBdw" = true || "$isByt" = true || "$isBsw" = true ) )  ]]; then
			#	restore_bitmaps
			#fiv
			info "This currently does nothing."
			sleep 5
			main_menu
			;;

		7)  if [[ "$unlockMenu" -= true || "$isChromeOS" == true ]]; then
				cros_disable_fc_enrl
				cros_drop_fakemurk
			fi
			main_menu
			;;

		8)  if [[ "$unlockMenu" = true || "$isBootStub" = true ]]; then
				cros_powerwash
			fi
			main_menu
			;;

		[rR])  echo -e "\nRebooting...\n";
			cleanup
			reboot
			exit
			;;

		[pP])  echo -e "\nPowering off...\n";
			cleanup
			poweroff
			exit
			;;

		[qQ])  cleanup;
			exit;
			;;

		[U])  if [ "$unlockMenu" = false ]; then
				echo_yellow "\nAre you sure you wish to unlock all menu functions?"
				read -ep "Only do this if you really know what you are doing... (or you're debugging) [y/N]? "
				[[ "$REPLY" = "y" || "$REPLY" = "Y" ]] && unlockMenu=true
			fi
			main_menu
			;;

		[vV]) if [[ "$unlockMenu" = true || "$verbose" == false ]]; then
				verbose=true
			fi
			main_menu
			;;

		*)  clear
			main_menu;
			;;
	esac
}
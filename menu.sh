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
	local os_type=$2
	if [[ "$param" == "ver" ]]; then
		if [[ "$osKernel" == "Linux" ]]; then
			echo -ne $(cat /etc/os-release | grep VERSION= | sed 's/.$//; s/^VERSION="//'^C)
		fi
	fi
}
function cleanup() {

}
function cleanup_dirty() {

}
function menu_header() {
    printf "\ec"
    clear
	echo -e "${NORMAL}\n Thien's OS debugging utility ${script_date} ${NORMAL}"
	echo -e "${MENU}*********************************************************${NORMAL}"
	echo -e "${MENU}**${NUMBER}		OS: ${NORMAL}$(ver_info "ver") (Running on ${osKernel})"
	if [[ $isChromeOS == true ]]; then
		echo -e "${MENU}**${NUMBER}		CrOS Platform: ${NORMAL}$(ver_info "board_ver" 1)"
		echo -e "${MENU}**${NUMBER}  	CrOS FW Info: ${NORMAL}$(ver_info "fw_info" 1)"
	fi
	echo -e "${MENU}**${NUMBER}  	Script Version: ${NORMAL}$(ver_info "script_ver") (date: $(ver_info "script_date"))"
	if [[ $isChromeOS == true ]]; then
		if [ "$wpEnabled" = true ]; then
			echo -e "${MENU}**${NUMBER}    Fw WP: ${RED_TEXT}Enabled${NORMAL}"
			WP_TEXT=${RED_TEXT}
		else
			echo -e "${MENU}**${NUMBER}    Fw WP: ${NORMAL}Disabled"
			WP_TEXT=${GREEN_TEXT}
		fi
	fi
	echo -e "${MENU}*********************************************************${NORMAL}"
}
function main_menu() {

	menu_header

	if [[ "$unlockMenu" = true || ( "$isFullRom" = false && "$isBootStub" = false && "$isUnsupported" = false && "$isEOL" = false ) ]]; then
		echo -e "${MENU}**${WP_TEXT}     ${NUMBER} 1)${MENU} Install/Update RW_LEGACY Firmware ${NORMAL}"
	else
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 1)${GRAY_TEXT} Install/Update RW_LEGACY Firmware ${NORMAL}"
	fi

	if [[ "$unlockMenu" = true || "$hasUEFIoption" = true || "$hasLegacyOption" = true ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 2)${MENU} Install/Update UEFI (Full ROM) Firmware ${NORMAL}"
	else
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 2)${GRAY_TEXT} Install/Update UEFI (Full ROM) Firmware${NORMAL}"
	fi
	if [[ "${device^^}" = "EVE" ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} D)${MENU} Downgrade Touchpad Firmware ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || ( "$isFullRom" = false && "$isBootStub" = false ) ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 3)${MENU} Set Boot Options (GBB flags) ${NORMAL}"
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 4)${MENU} Set Hardware ID (HWID) ${NORMAL}"
	else
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 3)${GRAY_TEXT} Set Boot Options (GBB flags)${NORMAL}"
		echo -e "${GRAY_TEXT}**     ${GRAY_TEXT} 4)${GRAY_TEXT} Set Hardware ID (HWID) ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || ( "$isFullRom" = false && "$isBootStub" = false && \
		("$isHsw" = true || "$isBdw" = true || "$isByt" = true || "$isBsw" = true )) ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 5)${MENU} Remove ChromeOS Bitmaps ${NORMAL}"
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 6)${MENU} Restore ChromeOS Bitmaps ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || ( "$isChromeOS" = false  && "$isFullRom" = true ) ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 7)${MENU} Restore Stock Firmware (full) ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || ( "$isByt" = true && "$isBootStub" = true && "$isChromeOS" = false ) ]]; then
		echo -e "${MENU}**${WP_TEXT} [WP]${NUMBER} 8)${MENU} Restore Stock BOOT_STUB ${NORMAL}"
	fi
	if [[ "$unlockMenu" = true || "$isUEFI" = true ]]; then
		echo -e "${MENU}**${WP_TEXT}     ${NUMBER} C)${MENU} Clear UEFI NVRAM ${NORMAL}"
	fi
	echo -e "${MENU}*********************************************************${NORMAL}"
	echo -e "${ENTER_LINE}Select a menu option or${NORMAL}"
	echo -e "${nvram}${RED_TEXT}R${NORMAL} to reboot ${NORMAL} ${RED_TEXT}P${NORMAL} to poweroff ${NORMAL} ${RED_TEXT}Q${NORMAL} to quit ${NORMAL}"
	
	read -e opt
	case $opt in

		1)  if [[ "$unlockMenu" = true || "$isEOL" = false && ("$isChromeOS" = true \
					|| "$isFullRom" = false && "$isBootStub" = false && "$isUnsupported" = false) ]]; then
				flash_rwlegacy
			fi
			menu_fwupdate
			;;

		2)  if [[  "$unlockMenu" = true || "$hasUEFIoption" = true || "$hasLegacyOption" = true ]]; then
				flash_coreboot
			fi
			menu_fwupdate
			;;

		[dD])  if [[  "${device^^}" = "EVE" ]]; then
				downgrade_touchpad_fw
			fi
			menu_fwupdate
			;;

		3)  if [[ "$unlockMenu" = true || "$isChromeOS" = true || "$isUnsupported" = false \
					&& "$isFullRom" = false && "$isBootStub" = false ]]; then
				set_boot_options
			fi
			menu_fwupdate
			;;

		4)  if [[ "$unlockMenu" = true || "$isChromeOS" = true || "$isUnsupported" = false \
					&& "$isFullRom" = false && "$isBootStub" = false ]]; then
				set_hwid
			fi
			menu_fwupdate
			;;

		5)  if [[ "$unlockMenu" = true || ( "$isFullRom" = false && "$isBootStub" = false && \
					( "$isHsw" = true || "$isBdw" = true || "$isByt" = true || "$isBsw" = true ) )  ]]; then
				remove_bitmaps
			fi
			menu_fwupdate
			;;

		6)  if [[ "$unlockMenu" = true || ( "$isFullRom" = false && "$isBootStub" = false && \
					( "$isHsw" = true || "$isBdw" = true || "$isByt" = true || "$isBsw" = true ) )  ]]; then
				restore_bitmaps
			fi
			menu_fwupdate
			;;

		7)  if [[ "$unlockMenu" = true || "$isChromeOS" = false && "$isUnsupported" = false \
					&& "$isFullRom" = true ]]; then
				restore_stock_firmware
			fi
			menu_fwupdate
			;;

		8)  if [[ "$unlockMenu" = true || "$isBootStub" = true ]]; then
				restore_boot_stub
			fi
			menu_fwupdate
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
				read -ep "Only do this if you really know what you are doing... [y/N]? "
				[[ "$REPLY" = "y" || "$REPLY" = "Y" ]] && unlockMenu=true
			fi
			menu_fwupdate
			;;

		[cC]) if [[ "$unlockMenu" = true || "$isUEFI" = true ]]; then
				clear_nvram
			fi
			menu_fwupdate
			;;

		*)  clear
			menu_fwupdate;
			;;
	esac
}
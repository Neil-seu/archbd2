#!/bin/sh
###############################################################
### Arch Installer Srcipt
###
### Copyright (C) 2017 Md. Tariqul Islam Neil
###
### By: Neil (Neil-seu)
### Email: tariqulislamseu@gmail.com
###
### Any questions, comments, or bug reports or suggestions and ideas may be sent to above
### email address. Enjoy, and keep on using Arch.
###
### License: GPL v3.0
###############################################################

#### Installing the base system


print_heading() {  						# Always use this function to clear the screen
  clear
  _Backtitle="Now Installing Base system..."
  T_COLS=$(tput cols)                   # Get width of terminal
  LenBT=${#_Backtitle}                  # Length of backtitle
  HalfBT=$((LenBT/2))
  tput cup 0 $(((T_COLS/2)-HalfBT))     # Move the cursor to left of center
  tput bold
  printf "%-s\n" "$_Backtitle"          # Display backtitle
  tput sgr0
  printf "%$(tput cols)s\n"|tr ' ' '-'  # Draw a line across width of terminal
  cursor_row=3                          # Save cursor row after heading
}



base_install() {

	dialog --backtitle "Archbd Installer Script" --title "Base Installing" --menu "Now choose any kernel:" 15 40 4 &> /dev/null

	options=(1 "LTS Kernel"
			 2 "Latest Development Kernel")

	CHOICE=$("${options[@]}")

	clear
	case $CHOICE in
			1 )
				print_heading
				pacstrap /mnt linux-lts linux-lts-headers parted btrfs-progs gtk-engines gtk-engine-murrine f2fs-tools git ntfs-3g fakechroot ntp net-tools iw wireless_tools wpa_actiond wpa_supplicant dialog alsa-utils espeakup rp-pppoe pavucontrol bluez bluez-utils pulseaudio-bluetooth brltty
				dialog --backtitle "Archbd Installer Script" --infobox "Base successfully installed!" 10 30 &> /dev/null
				sleep 2
			;;

			2 )
				print_heading
				pacstrap /mnt base base-devel linux-headers parted btrfs-progs gtk-engines gtk-engine-murrine f2fs-tools git ntfs-3g fakechroot ntp net-tools iw wireless_tools wpa_actiond wpa_supplicant dialog alsa-utils espeakup rp-pppoe pavucontrol bluez bluez-utils pulseaudio-bluetooth brltty
				dialog --backtitle "Archbd Installer Script" --infobox "Base successfully installed!" 10 30 &> /dev/null
				sleep 2
			;;
	esac
}
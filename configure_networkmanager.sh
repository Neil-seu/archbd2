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
  _Backtitle="Network Manager Selection"
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


arch_chroot() {
	arch-chroot /mnt /bin/bash -c "${1}"
}


configure_networkmanager() {

	clear
	dialog --backtitle "Archbd Installer Script" --title "Network Configuration" --menu "Now choose one Network Manager:" 15 40 4 &> /dev/null

	options=(1 "Network Manager"
			 2 "WICD manager (An alternative)")

	CHOICE=$("${options[@]}")

	clear
	case $CHOICE in
			1 )
				print_heading
				clear
				pacstrap /mnt networkmanager network-manager-applet dnsmasq nm-connection-editor networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc
				printf "\n"
				echo "Enabling Network manager service during boot..."
				printf "\n"
				arch_chroot "systemctl enable NetworkManager.service"
				printf "\n"		
				dialog --backtitle "Archbd Installer Script" --infobox "Network Manager successfully installed!" 10 40 &> /dev/null
				sleep 2
				break
			;;

			2 )
				print_heading
				clear
				pacstrap /mnt wicd wicd-gtk
				printf "\n"
				arch_chroot "systemctl enable wicd"
				printf "\n"
				dialog --backtitle "Archbd Installer Script" --infobox "WICD Manager successfully installed!" 10 40 &> /dev/null
				sleep 2
				break
			;;
	esac
}
#!/bin/bash

bluetooth_configure() {

clear

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Archbd Installer Script"
TITLE="-| Bluetooth Configuration |-"
MENU="Choose one of the following options:"

OPTIONS=(1 "Laptop"
	 2 "Desktop"
	 3 "Virtual Drive"
	 4 "None" )

CHOICE=$(dialog --clear \
	                --backtitle "$BACKTITLE" \
	                --title "$TITLE" \
	                --menu "$MENU" \
	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
	                "${OPTIONS[@]}" \
	                2>&1 >/dev/tty)

case $CHOICE in
	1) 
	   clear
	   pacstrap /mnt bluez bluez-utils blueman
	   printf "\n"
	   echo "Configuring bluetooth services..."
	   printf "\n"
	   arch_chroot "systemctl enable bluetooth.service"
	   printf "\n"
	   gsettings set org.blueman.plugins.powermanager auto-power-on true
	   clear
	   dialog --backtitle "Archbd Installer Script" --infobox "Successfully Configured!" 10 30
	   sleep 2
	   ;;
	 2)
	   clear
	   pacstrap /mnt bluez bluez-utils blueman
	   printf "\n"
	   echo "Configuring bluetooth services..."
	   printf "\n"
	   arch_chroot "systemctl enable bluetooth.service"
	   printf "\n"
	   gsettings set org.blueman.plugins.powermanager auto-power-on true
	   clear
	   dialog --backtitle "Archbd Installer Script" --infobox "Successfully Configured!" 10 30
	   sleep 2
	   ;;
	 3)
	   clear
	   pacstrap /mnt bluez bluez-utils blueman
	   printf "\n"
	   echo "Configuring bluetooth services..."
	   printf "\n"
	   arch_chroot "systemctl enable bluetooth.service"
	   printf "\n"
	   gsettings set org.blueman.plugins.powermanager auto-power-on true
	   clear
	   dialog --backtitle "Archbd Installer Script" --infobox "Successfully Configured!" 10 30
	   sleep 2
	   ;;
	 4)
	   clear
	   dialog --backtitle "Archbd Installer Script" --infobox "Skipping..." 10 30
	   sleep 2
	   ;;      	   

esac

}
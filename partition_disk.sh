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

partition_disk() {
	dialog --backtitle "Archbd Installer Script" --yesno "Now opening the cfdisk for bios-mbr scheme.
	This script doesn't support uefi-gpt.
	So use with caution!
	Press No if you don't want to configure your partition.

	Proceed?" 10 70
	response=$?
	clear
	if [[ "$response" -eq "Yes" ]]; then
    		printf '\e[1;33m%-6s\e[m' "List of your internal or external devices : "
		printf '\n'
		printf '\n'
		lsblk -o name,mountpoint,label,size,uuid
		printf "\n"
		printf "\n"
		printf '\e[1;33m%-6s\e[m' "Which one to do partition? Type it in full form like /dev/sdX.\n X means sda/sdb/sdc etc."
		printf "\n"
		printf "\n"
    		echo "Enter your choice:"
		read DEVICE_NUMBER
		cfdisk $DEVICE_NUMBER
		clear
		printf '\e[1;33m%-6s\e[m' "To format and mount, choose your partition in full form like /dev/sdX() you have just created from the list below :"
		printf "\n"
		printf "\n"
		lsblk -o name,mountpoint,label,size,uuid
		printf "\n"
		echo "Enter your choice:"
		read DEVICE_NUMBER
		printf '\e[1;33m%-6s\e[m' "formatting..."
		mkfs.ext4 $DEVICE_NUMBER
		printf '\e[1;32m%-6s\e[m' "format successful!"
		printf "\n"
		printf '\e[1;33m%-6s\e[m' "mounting root partition..."
		mount $DEVICE_NUMBER /mnt
		printf "\n"
		printf '\e[1;32m%-6s\e[m' "mount successful!"
		printf "\n"
		dialog --backtitle "Archbd Installer Script" --infobox "Partition Successfully configured!" 10 30
		sleep 3
		clear
	else
		break
	fi
	}


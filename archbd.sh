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

# check if the system is in root account

if [[ "$(id -u)" != "0" ]]; then
    	echo "Sorry, you are not root. Use 'sudo' or login as root account and try again."
    	exit 1
fi

arch_chroot() {
	arch-chroot /mnt /bin/bash -c "${1}"
}


clear
dialog --backtitle "Archbd Installer Script" --yesno "Welcome to Arch Installer. Proceed?" 10 30 
response=$?
clear
if [[ "$response" -eq "Yes" ]]
    then
       mount -o remount,size=4G /run/archiso/cowspace
       printf "\n"
       dialog --backtitle "Archbd Installer Script" --yesno "Do you want to refresh pacman keys (recommended)?" 10 30
       response=$?
       if [[ "$response" -eq "Yes" ]]
       	   then
	   	clear
       		printf '\e[1;33m%-6s\e[m' "Updating pacman keys...."
       		printf "\n"
	   		pacman-db-upgrade
	   		pacman-key --init
	   		pacman-key --populate archlinux
       		pacman-key --refresh-keys
       		dialog --backtitle "Archbd Installer Script" --infobox "Updated pacman keys successfully!" 10 30
       		sleep 3
       		clear
	   else
	   	break
	fi	
       pacman -Syy archlinux-keyring --noconfirm
       printf "\n"
       dialog --backtitle "Archbd Installer Script" --infobox "Successful!" 10 20
       sleep 3
       clear
    else
       break
fi

#dialog --backtitle "Archbd Installer Script" --infobox "Unmounting devices in case if any devices are already mounted. \
#	Please wait..." 10 40
#	umount -R /mnt
#	sleep 3
clear

mirror_rank
clear

partition_disk
clear
	
base_install
clear




#### Doing some basic stuff

set_root_password

set_hostname
clear

print_heading
printf "\n"
printf "\n"
printf '\e[1;33m%-6s\e[m' "## Setting your locale and generating the locale language: ##"
	echo 'name_servers="8.8.8.8 8.8.4.4"' >> /mnt/etc/resolvconf.conf
	sed -i 's/^#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/' /mnt/etc/locale.gen
	echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
	echo KEYMAP=us >> /mnt/etc/vconsole.conf
	printf "\n"
	arch-chroot /mnt locale-gen
	printf "\n"
	echo "Locale generation successful!"
	printf "\n"
	sleep 2
clear

print_heading
printf "\n"
printf '\e[1;33m%-6s\e[m' "## Now select your timezone: ##"
printf "\n"
	arch-chroot /mnt tzselect >> /mnt/etc/localtime
	arch_chroot "hwclock --systohc --utc" &> /dev/null
	printf "\n"
	echo "Success!"
	printf "\n"
	sleep 2

add_user
clear
set_user_password
clear

configure_networkmanager
clear

echo "Enabling other necessary services..."
printf "\n"
pacstrap /mnt 
arch_chroot "systemctl enable bluetooth.service"
printf "\n"
echo "DONE!"
printf "\n"
read -p "press enter to continue..."
sleep 2
clear

## Generating the fstab
printf '\e[1;33m%-6s\e[m' "##  Now generating the fstab, hold on... ##"
printf "\n"
genfstab -U -p /mnt >> /mnt/etc/fstab
printf "\n"
read -p "Success! press enter to continue..."
clear


## Configuring mkinitcpio
printf '\e[1;33m%-6s\e[m' "##  Now Configuring mkinitcpio... ##"
printf "\n"
arch_chroot "mkinitcpio -p linux"
printf "\n"
printf '\e[1;32m%-6s\e[m' " Done!"
printf "\n"
sleep 2
clear


## Installation and configuring GRUB
printf '\e[1;33m%-6s\e[m' "####  Now installing the GRUB for making the system bootable and detecting other OS in your HDD or SSD... ####"
printf "\n"
printf "\n"
pacstrap /mnt grub os-prober --noconfirm
clear
printf '\e[1;33m%-6s\e[m' "####  Now choose your HDD or SSD like /dev/sdX. X means sda/sdb/sdc: ####"
printf "\n"
lsblk -o name,mountpoint,label,size,uuid
printf "\n"
echo "Enter your choice:"
printf "\n"
read DEVICE_NUMBER
arch-chroot /mnt grub-install --target=i386-pc --recheck $DEVICE_NUMBER
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
printf "\n"
printf "\n"
read -p "Succes! press enter to proceed..."
clear

##### Installing Desktop environment and necessary drivers
printf '\e[1;33m%-6s\e[m' "######### Now Installing a Desktop environment: #########"
printf "\n"
sed -i '/\[multilib]/s/^#//g' /mnt/etc/pacman.conf
sed -i '/Include \= \/etc\/pacman\.d\/mirrorlist/s/^#//g' /mnt/etc/pacman.conf
sed -i -e '$a\\n[archlinuxfr]\nServer = http://repo.archlinux.fr/$arch\nSigLevel = Never' /mnt/etc/pacman.conf
sed -i -e '$a\\n[arch-anywhere]\nServer = https://arch-anywhere.org/repo/$arch\nSigLevel = Never' /mnt/etc/pacman.conf
sed -i 's/^#\[testing]/\[testing]/g' /mnt/etc/pacman.conf
#chmod 644 /mnt/etc/pacman.d/mirrorlist
#chmod 644 /mnt/etc/pacman.conf
printf "\n"
printf "Now choose your Desktop Environment: \n1. Xfce Desktop\n2. Gnome Desktop\n3. KDE Plasma Desktop\n4. Deepin Desktop\n5. Cinnamon Desktop\n6. Mate Desktop\n7. LXQT Desktop\n8. LXDE Desktop\n"
printf "\n"
printf "Enter the number:"
read environment
	if [ "$environment" = 1 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm xfce4 unrar unzip p7zip cpio xarchiver xfce4-goodies gtk-engine-murrine --noconfirm
	elif [ "$environment" = 2 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm gnome gnome-extra gnome-shell gtk-engine-murrine --noconfirm
	elif [ "$environment" = 3 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm plasma plasma-desktop kde-applications plasma-wayland-session --noconfirm
	elif [ "$environment" = 4 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm deepin deepin-extra --noconfirm
	elif [ "$environment" = 5 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm cinnamon gnome-extra --noconfirm
	elif [ "$environment" = 6 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm mate mate-extra --noconfirm
	elif [ "$environment" = 7 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm lxqt breeze-icons sddm connman --noconfirm
	elif [ "$environment" = 8 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-vesa xorg xorg-xinit xorg-twm xorg-xclock xterm lxde --noconfirm	
	else
		echo "Unknown Parameter"
	fi
	
printf "\n"
printf "### Success! ###"
printf "\n"
read -p "press enter to continue..."
clear
printf "Now choose your default login manager: \n1. Lightdm\n2. GDM\n3. SDDM\n4. Deepin (requires deepin desktop)"
printf "\n"
printf "Enter the number:"
read number
	if [ "$number" = 1 ]; then
		arch-chroot /mnt pacman -Syu lightdm lightdm-gtk-greeter --noconfirm		
		echo "Enabling login manager services..."
		arch-chroot /mnt systemctl enable lightdm.service
		#sed -i 's/^#exec startxfce4/exec startxfce4/' /mnt/home/$USERNAME/.xinitrc
	elif [ "$number" = 2 ]; then
		arch-chroot /mnt pacman -Syu gdm --noconfirm
		echo "Enabling login manager services..."
		arch-chroot /mnt systemctl enable gdm.service
		#sed -i -e '$a\exec gnome-session' /mnt/home/$USERNAME/.xinitrc
	elif [ "$number" = 3 ]; then
		arch-chroot /mnt pacman -Syu sddm --noconfirm
		echo "Enabling login manager services..."
		arch-chroot /mnt systemctl enable sddm.service
		#sed -i -e '$a\exec startkde' /mnt/home/$USERNAME/.xinitrc	
	elif [ "$number" = 4 ]; then
		arch-chroot /mnt pacman -Syu lightdm lightdm-gtk-greeter --noconfirm		
		echo "Enabling login manager services..."
		sed -i 's/^#greeter-session\=example-gtk-gnome/greeter-session\=lightdm-deepin-greeter/g' /mnt/etc/lightdm/lightdm.conf
		arch-chroot /mnt systemctl enable lightdm.service
		#sed -i -e '$a\exec startdde' /mnt/home/$USERNAME/.xinitrc
	else
		echo "Unknown parameter"
		break
	fi		
	
printf "\n"
echo "Done!"
printf "\n"
read -p "press enter to continue..."
clear
printf "Now choose your gpu to install it's driver: \n1. Nvidia open-source driver\n2. AMD open-source driver\n3. Intel\n"
printf "\n"
printf "Enter the number:"
read gpu
	if [ "$gpu" = 1 ]; then
		arch-chroot /mnt pacman -Syu lib32-mesa-libgl xf86-video-nouveau --noconfirm
	elif [ "$gpu" = 2 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-amdgpu xf86-video-ati lib32-mesa-libgl --noconfirm
	elif [ "$gpu" = 3 ]; then
		arch-chroot /mnt pacman -Syu xf86-video-intel lib32-mesa-libgl --noconfirm
	else 
		echo "Unknown parameter"
		break
	fi
	
printf "\n"     
echo "All drivers are successfully installed!"
printf "\n"
read -p "press enter to continue..."
clear

#### Installing Some common softwares
printf '\e[1;33m%-6s\e[m' "######### Let's install some common software: #########"
printf "\n"
arch-chroot /mnt pacman -Syu chromium google-chrome powerline-fonts zsh zsh-syntax-highlighting firefox ttf-inconsolata noto-fonts ttf-roboto adapta-gtk-theme evince yaourt deluge wget lolcat sublime-text-dev codeblocks gimp screenfetch gpick vlc smplayer smplayer-skins simplescreenrecorder gparted htop libreoffice-fresh bleachbit thunderbird bc rsync mlocate bash-completion pkgstats arch-wiki-lite tlp zip unzip unrar p7zip lzop cpio xdg-user-dirs-gtk ttf-bitstream-vera dosfstools exfat-utils f2fs-tools fuse fuse-exfat autofs mtpfs gvfs gvfs-goa gvfs-afc gvfs-mtp gvfs-google --noconfirm
printf "\n"
echo "Success!"
printf "\n"
read -p "press enter to continue..."
clear

## Unmounting devices in case if any devices are already mounted
umount -R /mnt
printf '\e[1;32m%-6s\e[m' "###### All dirty work is done & devices are already unmounted! ######"
printf "\n"
printf "\n"
read -p "press enter to reboot and unplug your USB or any CD-DVD drive..."
printf "\n"
reboot

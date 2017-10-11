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



##### Doing Some basic Stuffs


print_heading() {  						# Always use this function to clear the screen
  clear
  _Backtitle="Now Doing Some Basic Stuff"
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

set_root_password() {

	clear
	print_heading
	printf "\n"
	while (true)
	do
		echo "Enter root password: "
		read -s pass1
		printf "\n"
		echo "Re-enter root password: "
		read -s pass2

		if [ -z ${pass1} ] || [ -z ${pass2} ]; then
			clear
			print_heading
			printf "\n"
			echo "Password can't be blank, Try again."
			printf "\n"
			continue
		fi
		
		if [ $pass1 = $pass2 ]; then
			clear
			print_heading
			echo -e "${pass1}\n${pass2}" > /mnt/tmp/.passwd > /dev/null 2>$1
			arch_chroot "passwd root" < /tmp/.passwd > /dev/null 2>$1
			rm /mnt/tmp/.passwd
			printf "\n"
			echo "Password updated successfully!"
			sleep 2
			break
		else
			print_heading
			printf "\n"
			echo "Password doesn't match."
			printf "\n"
			continue
		fi			
}


add_user() {

	clear
	print_heading
	printf "\n"
	printf "\n"
	printf "Now add your username. If you leave it blank intentionally or unintentionally, archbd will be the username.\n"
	printf "\n"
	printf "\n"
	echo "Enter the user name: "
	read usr &> /dev/null
	#checkuser=`cat /mnt/etc/passwd | grep ${usr}` &> /dev/null

	if [[ -z "${usr}" ]]; then
			print_heading
			echo "Adding and setting username..."
			arch_chroot "useradd archbd -m -g users -G wheel,storage,power,network,video,audio,lp -s /bin/bash" &> /dev/null
			arch_chroot "cp /etc/skel/.bashrc /home/archbd" &> /dev/null
			arch_chroot "chown -R archbd:users /home/archbd" &> /dev/null
			sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /mnt/etc/sudoers &> /dev/null
			printf "\n"
			echo "username added successfully!"
			printf "\n"
			sleep 2
			break
	else
			print_heading
			echo "Adding and setting username..."
			arch_chroot "useradd ${usr} -m -g users -G wheel,storage,power,network,video,audio,lp -s /bin/bash" &> /dev/null
			arch_chroot "cp /etc/skel/.bashrc /home/${usr}" &> /dev/null
			arch_chroot "chown -R ${usr}:users /home/${usr}" &> /dev/null
			sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /mnt/etc/sudoers &> /dev/null
			printf "\n"
			echo "username added successfully!"
			printf "\n"
			sleep 2
			break	
	fi	
}


set_user_password() {

	clear
	print_heading
	printf "\n"
	while (true)
	do
		echo "Enter password for new user: "
		read -s pass1 &> /dev/null
		printf "\n"
		echo "Re-enter the password: "
		read -s pass2 &> /dev/null

		if [ -z ${pass1} ] || [ -z ${pass2} ]; then
			clear
			print_heading
			printf "\n"
			echo "Password can't be blank, Try again."
			printf "\n"
			continue
		fi
		
		if [ $pass1 = $pass2 ]; then
			print_heading
			echo -e "${pass1}\n${pass2}" > /mnt/tmp/.passwd &> /dev/null
			arch_chroot "passwd ${usr}" < /tmp/.passwd &> /dev/null
			rm /mnt/tmp/.passwd &> /dev/null
			printf "\n"
			echo "Password updated successfully!"
			sleep 2
			break
		else
			clear
			print_heading
			printf "\n"
			echo "Password doesn't match."
			printf "\n"
			continue
		fi		
	done		
}


set_hostname() {

	clear
	print_heading
	printf "\n"
	printf "\n"
	printf "Set your hostname. If you leave it blank, archlinux will be the hostname.\n"
	printf "\n"
	printf "\n"
	echo "Hostname: "
	read HOSTNAME &> /dev/null

	if [[ -z "${HOSTNAME}" ]]; then
		echo "archlinux" > /mnt/etc/hostname &> /dev/null
		printf "\n"
		echo "Hostname added!"
		sleep 2
		break
	else
		echo "$HOSTNAME" > /mnt/etc/hostname &> /dev/null
		printf "\n"
		echo "Hostname added!"
		sleep 2
		break	
	fi
}



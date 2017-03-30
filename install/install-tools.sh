#!/usr/bin/env bash

installDir=/archInstall

. $installDir/pacaut-install.sh

#virtual box
sudo pacman -S virtualbox virtualbox-host-modules-arch
sudo modprobe -a vboxdrv
sudo echo 'vboxdrv' >> /etc/modules-load.d/virtualbox.conf
sudo gpasswd -a $USER vboxusers


sudo pacman -S maven gradle git notepadqq
sudo pacaur -S jdk intellij-idea-ultimate-edition teamviewer

sudo archlinux-java java-8-jdk


#Setting some util commands
echo " " >> ~/.bashrc
echo alias ll='ls -la' >> ~/.bashrc
echo alias process="watch -n 1 'ps -e -o pid,uname,cmd,pmem,pcpu --sort=-pmem,-pcpu | head -15'" >> ~/.bashrc
tee -a ~/.bashrc <<EOF
log() {
	local logPath=~/logs/system/$(date +%Y)/$(date +%m)/$(date +%d)
	local fileLog=$logPath/$(date +%H)_$(date +%M)_$(date +%S).log

	mkdir -p $logPath

	echo "" >> $fileLog
	echo -------------$(history 1)--------------- >> $fileLog
	echo "" >> $fileLog

	echo tee -a $fileLog 2>&1
}
EOF
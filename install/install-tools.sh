#!/usr/bin/env bash

installDir=/archInstall

. $installDir/pacaut-install.sh

pacaur -S jdk intellij-idea-ultimate-edition teamviewer maven gradle git notepadqq virtualbox virtualbox-host-modules-arch redshift gnome-tweak-tool

#jdk conf
archlinux-java set java-8-jdk

#vb conf
sudo modprobe -a vboxdrv
sudo echo 'vboxdrv' >> /etc/modules-load.d/virtualbox.conf
sudo gpasswd -a $USER vboxusers


#redshift conf
sudo tee -a /etc/geoclue/geoclue.conf <<EOF

[redshift]
allowed=true
system=false
users=
EOF


#tw conf
systemctl enable teamviewerd.service
systemctl start teamviewerd.service


#Setting some util commands
echo " " >> ~/.bashrc
#terminal: ll
echo alias ll='ls -la' >> ~/.bashrc
#terminal: process
echo alias process="watch -n 1 'ps -e -o pid,uname,cmd,pmem,pcpu --sort=-pmem,-pcpu | head -15'" >> ~/.bashrc
#terminal: command | $(log)
tee -a ~/.bashrc <<EOF
log() {
	local logPath=~/logs/system/\$(date +%Y)/\$(date +%m)/\$(date +%d)
	local fileLog=$logPath/\$(date +%H)_\$(date +%M)_\$(date +%S).log

	mkdir -p $logPath

	echo "" >> $fileLog
	echo -------------\$(history 1)--------------- >> $fileLog
	echo "" >> $fileLog

	echo tee -a $fileLog 2>&1
}
EOF
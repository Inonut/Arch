#!/usr/bin/env bash

installDir=/archInstall

. $installDir/pacaut-install.sh

pacaur -S jdk intellij-idea-ultimate-edition teamviewer maven gradle git notepadqq virtualbox virtualbox-host-modules-arch redshift gnome-tweak-tool megasync conky chrome-gnome-shell-git

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


#conky conf
tee -a ~/.config/autostart/conky.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=conky
Comment=
Exec=conky -d
StartupNotify=false
Terminal=false
Hidden=false
EOF


#chrome-gnome-shell-git conf
#https://extensions.gnome.org/

#Setting some util commands
tee -a ~/.bashrc <<EOF

alias ll='ls -la'
alias process="watch -n 1 'ps -e -o pid,uname,cmd,pmem,pcpu --sort=-pmem,-pcpu | head -15'"

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
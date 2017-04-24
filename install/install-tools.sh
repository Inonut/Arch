#!/usr/bin/env bash

installDir=/archInstall


conf_bashrc(){
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
}


install(){
    for var in $@
    do
        if [ -n "$(type -t $var)" ] && [ "$(type -t $var)" = function ];
        then
            echo Config $var
            $var
        else
            echo Install $var
            pacaur -S $var
        fi
    done
}

conf_jdk(){
    sudo archlinux-java set java-8-jdk
}

conf_teamviewer(){
    systemctl enable teamviewerd.service
    systemctl start teamviewerd.service
}

conf_virtualbox(){
    sudo modprobe -a vboxdrv
    sudo echo 'vboxdrv' >> /etc/modules-load.d/virtualbox.conf
    sudo gpasswd -a $USER vboxusers
}

conf_redshift(){
sudo tee -a /etc/geoclue/geoclue.conf <<EOF

[redshift]
allowed=true
system=false
users=
EOF
}


conf_conky(){
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
}


. $installDir/pacaut-install.sh

install jdk conf_jdk
install intellij-idea-ultimate-edition
install maven
install gradle
install git
install notepadqq
install virtualbox virtualbox-host-modules-arch conf_virtualbox
install redshift conf_redshift
install megasync
install conky
#install gnome-tweak-tool
#install chrome-gnome-shell-git #https://extensions.gnome.org/
install gdevilspie
install downgrade
install gst-libav gst-plugins-good #deepin-music fixed
install conf_bashrc



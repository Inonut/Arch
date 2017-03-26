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
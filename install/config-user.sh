#!/usr/bin/env bash

#read props
installDir=/archInstall
. $installDir/readProps.sh

create_user() {
    local name="$1"; shift
    local password="$1"; shift

    useradd -m -G wheel -s /bin/bash "$name"
    echo -en "$password\n$password" | passwd "$name"
}

set_sudo() {
    yes | pacman -S sudo

    echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

}

set_interface() {

    pacman -S xorg
    pacman -S gnome
    pacman -S deepin deepin-extra deepin-extras

    sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/g' /etc/lightdm/lightdm.conf
}



echo '-------------Configuration---------------'

echo 'Creating initial user'
create_user "$USER_NAME" "$USER_PASSWORD"

echo 'Setting sudo'
set_sudo

echo 'Setting interface'
set_interface

echo 'Strat interface'
systemctl enable lightdm.service
systemctl start lightdm.service

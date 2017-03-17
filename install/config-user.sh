#!/usr/bin/env bash

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

    yes | pacman -Syu
    yes | pacman -Scc
    printf '\n\n\ny' | pacman -S xorg xorg-server xorg-server-utils
    printf '\n\ny' | pacman -S gnome gdm
    yes | pacman -S open-vm-tools
}



echo '-------------Configuration---------------'

echo 'Creating initial user'
create_user "$USER_NAME" "$USER_PASSWORD"

echo 'Setting sudo'
set_sudo

echo 'Setting interface'
set_interface

echo 'Strat interface'
systemctl enable gdm.service
#systemctl start gdm

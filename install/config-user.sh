#!/usr/bin/env bash

create_user() {
    local name="$1"; shift
    local password="$1"; shift

    useradd -m -G wheel -s /bin/bash "$name"
    echo -en "$password\n$password" | passwd "$name"
    echo '%wheel ALL=(ALL)' > /etc/sudoers
}

set_interface() {

    $USER_PASSWORD | sudo
    yes | sudo pacman -Syu
    printf '\ny\n' | sudo pacman -S xorg-server xorg-server-utils
    printf '\n\ny\n' | sudo pacman -S gnome gdm
    yes | sudo pacman -S open-vm-tools
}



echo '-------------Configuration---------------'

echo 'Creating initial user'
create_user "$USER_NAME" "$USER_PASSWORD"

su - $USER_NAME
reset

echo 'Setting interface'
set_interface

logout

echo 'Strat interface'
systemctl enable gdm.service
systemctl start gdm

rm /config.sh
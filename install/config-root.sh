#!/usr/bin/env bash

#read props
installDir=/archInstall
. $installDir/readProps.sh


set_repository() {
    #The multilib repository is an official repository which allows the user to run and build 32-bit applications on 64-bit installations of Arch Linux
    echo '[multilib]' >> /etc/pacman.conf
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
}

update_packs() {
    yes | pacman -Syuw # download packages
    rm /etc/ssl/certs/ca-certificates.crt # remove conflicting file
    yes | pacman -Su # perform upgrade
    yes | pacman -S dialog
}

set_syslinux() {
    local dev="$1"; shift

    mkinitcpio -p linux
    yes | pacman -S grub bash-completion os-prober intel-ucode
    grub-install --recheck "$dev"
    grub-mkconfig -o /boot/grub/grub.cfg

}

set_hostname() {
    local hostname="$1"; shift

    echo "$hostname" >> /etc/hostname
}

set_hosts() {
    local hostname="$1"; shift

    cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $hostname
::1       localhost.localdomain localhost
EOF
}

set_network() {
    local net="$1"; shift

    yes | pacman -S networkmanager
    systemctl enable NetworkManager.service
}


set_locale() {
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    echo "en_US ISO-8859-1" >> /etc/locale.gen
    locale-gen
    echo LANG=en_US.UTF-8 >> /etc/locale.conf
}

set_timezone() {
    local timezone="$1"; shift

    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    hwclock --systohc --utc
}

set_root_password() {
    local password="$1"; shift

    echo -en "$password\n$password" | passwd
}



echo '-------------Configuration---------------'

echo 'Setting repository'
set_repository

echo 'Update packs'
update_packs

echo 'Configuring bootloader'
set_syslinux "$DRIVE"

echo 'Setting hostname'
set_hostname "$HOSTNAME"

echo 'Setting hosts file'
set_hosts "$HOSTNAME"

echo 'Setting network'
set_network "$NETWORK"

echo 'Setting locale'
set_locale

echo 'Setting timezone'
set_timezone "$TIMEZONE"

echo 'Setting root password'
set_root_password "$ROOT_PASSWORD"

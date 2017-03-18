#!/usr/bin/env bash

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

set_syslinux() {
    local dev="$1"; shift

    mkinitcpio -p linux
    yes | pacman -S grub bash-completion os-prober
    grub-install --recheck "$dev"
    grub-mkconfig -o /boot/grub/grub.cfg

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

    systemctl enable dhcpcd@"$net".service
}

set_repository() {
    #sed -e '/[multilib]/ s/^#*//' -i /etc/pacman.conf
    #sed -e '/include = /etc/pacman.d/mirrorlist/ s/^#*//' -i /etc/pacman.conf

    echo '[multilib]' >> /etc/pacman.conf
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

    yes | pacman -Syu
    yes | pacman -Scc
}


install_packages() {
    local packages='dialog'

    yes | pacman -S "$packages"
}


set_hostname() {
    local hostname="$1"; shift

    echo "$hostname" >> /etc/hostname
}

set_keymap() {
    echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf
}

set_root_password() {
    local password="$1"; shift

    echo -en "$password\n$password" | passwd
}



echo '-------------Configuration---------------'


echo 'Setting locale'
set_locale

echo 'Setting timezone'
set_timezone "$TIMEZONE"

echo 'Configuring bootloader'
set_syslinux "$DRIVE"

echo 'Setting hostname'
set_hostname "$HOSTNAME"

echo 'Setting hosts file'
set_hosts "$HOSTNAME"

echo 'Setting network'
set_network "$NETWORK"

echo 'Setting repository'
set_repository

echo 'Installing additional packages'
install_packages

echo 'Setting console keymap'
set_keymap

echo 'Setting root password'
set_root_password "$ROOT_PASSWORD"

rm config-root.sh
#!/bin/bash

#Constants
DRIVE='/dev/sda'
HOSTNAME='arch'
TIMEZONE='Europe/Bucharest'
KEYMAP='us'
ROOT_PASSWORD=''
USER_NAME=''
USER_PASSWORD=''

setup() {
    echo 'Creating partitions'
    partition_drive "$DRIVE"

    echo 'Formatting filesystems'
    format_filesystems "$DRIVE"

    echo 'Mounting filesystems'
    mount_filesystems "$DRIVE"

    echo 'Choose closest mirror list'
    choose_mirror

    echo 'Installing base system'
    install_base

    echo '-------------Configuration---------------'
    configure

    exit
    echo 'Unmounting filesystems'
    unmount_filesystems
    echo 'Done! Reboot system.'
    reboot
}

configure() {
    echo 'Setting repository'
    set_repository

    echo 'Installing additional packages'
    install_packages

    echo 'Clearing package tarballs'
    clean_packages

    echo 'Updating pkgfile database'
    update_pkgfile

    echo 'Setting hostname'
    set_hostname "$HOSTNAME"

    echo 'Setting timezone'
    set_timezone "$TIMEZONE"

    echo 'Setting locale'
    set_locale

    echo 'Setting console keymap'
    set_keymap

    echo 'Setting hosts file'
    set_hosts "$HOSTNAME"

    echo 'Setting fstab'
    set_fstab

    echo 'Configuring bootloader'
    set_syslinux "$DRIVE"

    echo 'Setting root password'
    set_root_password "$ROOT_PASSWORD"

    echo 'Creating initial user'
    create_user "$USER_NAME" "$USER_PASSWORD"

}


partition_drive() {
    local dev="$1"; shift

    # Must be refactor for real masine
    parted -s "$dev" \
        mklabel msdos \
        mkpart primary ext4 1 100M \
        mkpart primary ext4 100M 2G \
        mkpart primary ext4 2G 3G \
        mkpart primary ext4 3G 100% \
        set 1 boot on
}


format_filesystems() {
    local dev="$1"; shift

    mkfs.ext4 "$dev"2
    mkfs.ext4 "$dev"4
    mkswap "$dev"3
    swapon "$dev"3
}


mount_filesystems() {
    local dev="$1"; shift

    mount "$dev"2 /mnt
    mkdir /mnt/boot
    mount "$dev"1 /mnt/boot
    mkdir /mnt/home
    mount "$dev"4 /mnt/home
}

choose_mirror() {
    pacman -Sy
    pacman -S reflector
    reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist
}


install_base() {
    pacstrap -i /mnt base base-devel
}


set_repository() {
    #sed -e '/[multilib]/ s/^#*//' -i /etc/pacman.conf
    #sed -e '/include = /etc/pacman.d/mirrorlist/ s/^#*//' -i /etc/pacman.conf

    echo '[multilib]' >> /etc/locale.conf
    echo 'include = /etc/pacman.d/mirrorlist' >> /etc/locale.conf

    pacman -Sy
}


install_packages() {
    local packages=''

    #pacman -Sy --noconfirm $packages
}


clean_packages() {
    yes | pacman -Scc
}


update_pkgfile() {
    pkgfile -u
}


set_hostname() {
    local hostname="$1"; shift

    echo "$hostname" > /etc/hostname
}


set_timezone() {
    local timezone="$1"; shift

    ln -sT "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
}


set_locale() {
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
    export LANG=en_US.UTF-8
}


set_keymap() {
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
}


set_hosts() {
    local hostname="$1"; shift

    cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $hostname
::1       localhost.localdomain localhost $hostname
EOF
}

set_fstab() {
    genfstab -U -p /mnt >> /mnt/etc/fstab
}

set_syslinux() {
    local dev="$1"; shift

    mkinitcpio -p linux
    pacman -S grub os-prober
    grub-install "$dev"
    grub-mkconfig -o /boot/grub/grub.cfg

}


set_root_password() {
    local password="$1"; shift

    echo -en "$password\n$password" | passwd
    pacman -S sudo bash-completion
}

create_user() {
    local name="$1"; shift
    local password="$1"; shift

    useradd -m -g users -G wheel,storage,power -s /bin/bash "$name"
    echo -en "$password\n$password" | passwd "$name"
    echo '%wheel ALL=(ALL)' >> EDITOR=nano visudo
}

unmount_filesystems() {
    umount -R /mnt
}

set -ex

setup
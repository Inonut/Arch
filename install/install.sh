#!/bin/bash

#Constants
DRIVE='/dev/sda'
HOSTNAME='arch'
TIMEZONE='Europe/Bucharest'
#KEYMAP='us'
ROOT_PASSWORD='asd'
USER_NAME='gogu'
USER_PASSWORD='asd'
NETWORK='enp0s3'




set_network() {
    local net="$1"; shift

    systemctl enable dhcpcd@"$net".service
}

partition_drive() {
    local dev="$1"; shift

    # Must be refactor for real masine
    parted -s "$dev" \
        mklabel msdos \
        mkpart primary ext4 1 100M \
        mkpart primary ext4 100M 7G \
        mkpart primary linux-swap 7G 8G \
        mkpart primary ext4 8G 100% \
        set 1 boot on
}


format_filesystems() {
    local dev="$1"; shift

    mkfs.ext4 "$dev"1
    mkfs.ext4 "$dev"2
    mkswap "$dev"3
    mkfs.ext4 "$dev"4
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
    local packages='dialog'

    pacman -Sy --noconfirm "$packages"
}


clean_packages() {
    yes | pacman -Scc
}


update_pkgfile() {
    pkgfile -u
}


set_chroot() {
    arch-chroot /mnt /bin/bash
}

set_hostname() {
    local hostname="$1"; shift

    echo "$hostname" > /etc/hostname
}


set_timezone() {
    local timezone="$1"; shift

    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    hwclock --systohc --utc
}


set_locale() {
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
    echo "en_US ISO-8859-1" > /etc/locale.gen
    locale-gen
    echo LANG=en_US.UTF-8 > /etc/locale.conf
}


set_keymap() {
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
}


set_hosts() {
    local hostname="$1"; shift

    cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $hostname
::1       localhost.localdomain localhost
EOF
}

set_fstab() {
    genfstab -U /mnt >> /mnt/etc/fstab
}

set_syslinux() {
    local dev="$1"; shift

    mkinitcpio -p linux
    pacman -S grub os-prober
    grub-install --recheck "$dev"
    grub-mkconfig -o /boot/grub/grub.cfg

}


set_root_password() {
    local password="$1"; shift

    echo -en "$password\n$password" | passwd
#    pacman -S sudo bash-completion
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





setup() {
    echo '-------------Setup---------------'

    echo 'Creating partitions'
    partition_drive "$DRIVE"

    echo 'Formatting filesystems'
    format_filesystems "$DRIVE"

    echo 'Mounting filesystems'
    mount_filesystems "$DRIVE"

    #echo 'Choose closest mirror list'
    #choose_mirror

    echo 'Installing base system'
    install_base

    echo 'Setting fstab'
    set_fstab

    echo 'Chrooting into installed system to continue setup...'
    cp $0 /mnt/setup.sh
    arch-chroot /mnt ./setup.sh chroot

    if [ -f /mnt/setup.sh ]
    then
        echo 'ERROR: Something failed inside the chroot, not unmounting filesystems so you can investigate.'
        echo 'Make sure you unmount everything before you try to run this script again.'
    else
        echo 'Unmounting filesystems'
        unmount_filesystems
        echo 'Done! Reboot system.'
    fi
}

configure() {

    echo '-------------Configuration---------------'

#    echo 'Setting chroot'
#    set_chroot

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

    #echo 'Setting repository'
    #set_repository

    echo 'Installing additional packages'
    install_packages

    echo 'Clearing package tarballs'
    clean_packages

    echo 'Updating pkgfile database'
    update_pkgfile

    #echo 'Setting console keymap'
    #set_keymap

    echo 'Setting root password'
    set_root_password "$ROOT_PASSWORD"

    #echo 'Creating initial user'
    #create_user "$USER_NAME" "$USER_PASSWORD"

    rm /setup.sh
}




echo '----------------------------------------------------------'

set -ex

if [ "$1" == "chroot" ]
then
    configure
else
    setup
fi



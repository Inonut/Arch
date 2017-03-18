#!/bin/bash

. readProps.sh

partition_drive() {
    local dev="$1"; shift

    # Must be refactor for real masine
#    parted -s "$dev" \
#        mklabel msdos \
#        mkpart primary ext4 1 100M \
#        mkpart primary ext4 100M 7G \
#        mkpart primary linux-swap 7G 8G \
#        mkpart primary ext4 8G 100% \
#        set 1 boot on

    parted -s "$dev" \
        mklabel msdos \
        mkpart primary linux-swap 1 1G \
        mkpart primary ext4 1G 100% \
        set 2 boot on
}


format_filesystems() {
    local dev="$1"; shift

#    mkfs.ext4 "$dev"1
#    mkfs.ext4 "$dev"2
#    mkswap "$dev"3
#    mkfs.ext4 "$dev"4
#    swapon "$dev"3

    mkswap "$dev"1
    swapon "$dev"1
    mkfs.ext4 "$dev"2
}


mount_filesystems() {
    local dev="$1"; shift

#    mount "$dev"2 /mnt
#    mkdir /mnt/boot
#    mount "$dev"1 /mnt/boot
#    mkdir /mnt/home
#    mount "$dev"4 /mnt/home

    mount "$dev"2 /mnt
}

update_packs() {
    yes | pacman -Syu
    yes | pacman -Scc
}

choose_mirror() {
    yes | pacman -S reflector
    reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist
}


install_base() {
    printf '\n\ny\n' | pacstrap -i /mnt base base-devel
}

set_fstab() {
    genfstab -U /mnt >> /mnt/etc/fstab
}

unmount_filesystems() {
    umount -R /mnt
}






echo '-------------Setup---------------'

echo 'Creating partitions'
partition_drive "$DRIVE"

echo 'Formatting filesystems'
format_filesystems "$DRIVE"

echo 'Mounting filesystems'
mount_filesystems "$DRIVE"

echo 'Update packs'
update_packs

echo 'Choose closest mirror list'
choose_mirror

echo 'Installing base system'
install_base

echo 'Setting fstab'
set_fstab

echo 'Chrooting into installed system to continue setup...'
cp $installDir /mnt$installDir
arch-chroot /mnt /bin/bash $installDir/config-root.sh

echo 'Unmounting filesystems'
unmount_filesystems
echo 'Done! Reboot system.'
#reboot




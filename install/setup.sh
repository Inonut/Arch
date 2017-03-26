#!/bin/bash

#read props
installDir=/archInstall
. $installDir/readProps.sh

partition_drive() {
    local dev="$1"; shift

    #make partition. See https://wiki.archlinux.org/index.php/Partitioning?#Example_layouts
    parted -s "$dev" \
        mklabel msdos \
        mkpart primary linux-swap 1M 8G \
        mkpart primary ext4 8G 100% \
        set 2 boot on
}


format_filesystems() {
    local dev="$1"; shift

    #create swap space
    mkswap "$dev"1
    #start swap
    swapon "$dev"1
    #Formatting partitions
    mkfs.ext4 "$dev"2
}


mount_filesystems() {
    local dev="$1"; shift

    #mount partition
    mount "$dev"2 /mnt
}


install_base() {
    #Install base arch linux. "printf '\n\ny\n'" is used for answer to pacstrap
    printf '\n\ny\n' | pacstrap -i /mnt base base-devel
}

set_fstab() {
    #Write partition in "/mnt/etc/fstab"
    genfstab -U /mnt >> /mnt/etc/fstab
}

unmount_filesystems() {
    #Unmount partition
    umount -R /mnt
}






echo '-------------Setup---------------'

echo 'Creating partitions'
partition_drive "$DRIVE"

echo 'Formatting filesystems'
format_filesystems "$DRIVE"

echo 'Mounting filesystems'
mount_filesystems "$DRIVE"

echo 'Installing base system'
install_base

echo 'Setting fstab'
set_fstab

echo 'Chrooting into installed system to continue setup...'
#Copy install scripts in now root
cp -R $installDir /mnt$installDir
arch-chroot /mnt /bin/bash $installDir/config-root.sh

echo 'Unmounting filesystems'
unmount_filesystems
echo 'Done! Reboot system.'




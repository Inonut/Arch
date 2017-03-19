#!/usr/bin/env bash


installDir=/archInstall
. $installDir/readProps.sh


tools=(
    jdk
    intellij-idea-ultimate-edition
)

for tool in ${tools[@]}
do
    curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/$tool.tar.gz
    tar -xvf $tool.tar.gz
    cd ~/$tool
    printf '\n\n\n\n\n\n\n\n\n' | makepkg -s
    printf '$USER_PASSWORD\n\n' | makepkg -i
    cd ~/
    rm -rf $tool
    rm -rf $tool.tar.gz
done


printf '\n\n\n\n\n\n\n\n\n' | pacman -S maven gradle git notepadqq virtualbox
printf '$USER_PASSWORD' | sudo !!
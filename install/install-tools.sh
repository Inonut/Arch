#!/usr/bin/env bash


tools=(
    jdk
    intellij-idea-ultimate-edition
)

for tool in ${tools[@]}
do
    curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/$tool.tar.gz
    tar -xvf $tool.tar.gz
    cd ~/$tool
    makepkg -si
    cd ~/
    rm -rf $tool
    rm -rf $tool.tar.gz
done


pacman -S maven gradle git notepadqq virtualbox


archlinux-java java-8-jdk
#!/usr/bin/env bash

installDir=/archInstall

. $installDir/pacaut-install.sh

pacman -S maven gradle git notepadqq virtualbox
pacaur -S jdk intellij-idea-ultimate-edition

archlinux-java java-8-jdk
#!/usr/bin/env bash

declare -A props

props['DRIVE']=/dev/sda
props['HOSTNAME']=arch
props['TIMEZONE']=Europe/Bucharest
props['KEYMAP']=us
props['ROOT_PASSWORD']=asd
props['USER_NAME']=gogu
props['USER_PASSWORD']=asd
props['NETWORK']=enp0s3
props['COUNTRY']=Romania

installDir=/archInstall

mkdir $installDir

for k in "${!props[@]}"
do
    echo $k=${props[$k]} >> $installDir/constants.properties
done

curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/readProps.sh > $installDir/readProps.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/setup.sh > $installDir/setup.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-root.sh > $installDir/config-root.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-user.sh > $installDir/config-user.sh

. $installDir/setup.sh
. $installDir/config-user.sh
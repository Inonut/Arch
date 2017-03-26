#!/usr/bin/env bash

declare -A props

#Variable used for installation and configuratin
props['DRIVE']=/dev/sda
props['HOSTNAME']=arch
props['TIMEZONE']=Europe/Bucharest
props['ROOT_PASSWORD']=asd
props['USER_NAME']=gogu
props['USER_PASSWORD']=asd

#This scripts will remain in "/archInstall" after finish installation
installDir=/archInstall

mkdir $installDir

#That variables are write in constants file. Scripts read variable from it with readProps.sp
#for each key append on last key=value in "constants.properties"
for k in "${!props[@]}"
do
    echo $k=${props[$k]} >> $installDir/constants.properties
done

echo 'Download scripts'
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/readProps.sh > $installDir/readProps.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/setup.sh > $installDir/setup.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-root.sh > $installDir/config-root.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-user.sh > $installDir/config-user.sh

#run setup.sh with configured runner (first line from .sh)
. $installDir/setup.sh
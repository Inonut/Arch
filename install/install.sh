#!/bin/bash


installDir=/archInstall

echo 'DRIVE=/dev/sda' >> constants.properties
echo 'HOSTNAME=arch' >> constants.properties
echo 'TIMEZONE=Europe/Bucharest' >> constants.properties
echo 'KEYMAP=us' >> constants.properties
echo 'ROOT_PASSWORD=asd' >> constants.properties
echo 'USER_NAME=gogu' >> constants.properties
echo 'USER_PASSWORD=asd' >> constants.properties
echo 'NETWORK=enp0s3' >> constants.properties
echo 'COUNTRY=Romania' >> constants.properties

rm -r $installDir
mkdir $installDir

curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/readProps.sh > $installDir/readProps.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/setup.sh > $installDir/setup.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-root.sh > $installDir/config-root.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-user.sh > $installDir/config-user.sh

. $installDir/setup.sh
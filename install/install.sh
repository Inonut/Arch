#!/bin/bash


installDir=/archInstall

rm -r $installDir
mkdir $installDir

curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/constants.properties > $installDir/constants.properties
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/readProps.sh > $installDir/readProps.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/setup.sh > $installDir/setup.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-root.sh > $installDir/config-root.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config-user.sh > $installDir/config-user.sh

echo "installDir=/archInstall" >> $installDir/constants.properties

sh $installDir/setup.sh
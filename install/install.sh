#!/bin/bash

#Constants
export DRIVE='/dev/sda'
export HOSTNAME='arch'
export TIMEZONE='Europe/Bucharest'
#export KEYMAP='us'
export ROOT_PASSWORD='asd'
export USER_NAME='gogu'
export USER_PASSWORD='asd'
export NETWORK='enp0s3'


mkdir /archInstall
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/setup.sh > /archInstall/setup.sh
curl -L https://raw.githubusercontent.com/Inonut/Arch/master/install/config.sh > /archInstall/config.sh


sh setup.sh

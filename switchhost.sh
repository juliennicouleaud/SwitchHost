#!/bin/bash

################
## Configuration

hostpath="/etc/"


################
## Check if root

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


################
## Read location and set IP

echo "Where are you?"
echo "1. Home"
echo "2. Work"
echo "3. Bonnet"
echo "4. Mobile share"
echo "5. Host only"
echo "6. Temp"

read reponse
case $reponse in
    [1] | [home]*) ip="192.168.1.62";;
    [2] | [Work]*) ip="192.168.35.165";;
    [3] | [bonnet]*) ip="192.168.1.17";;
    [4] | [honor]*) ip="192.168.43.94";;
    [5] | [host]*) ip="192.168.56.102";;
    [6] | [temp]*) ip="192.168.56.102";;
    *) echo "Erreur de saisie"
        exit 1;;
esac


################
## Backup hosts file et remplace par le template

echo "Backup current host file"
cp "$hostpath"hosts "$hostpath"hosts-backup-$(date +%y-%m-%d)--$(date +"%T")
rm "$hostpath"hosts
echo "Replace current host file with template"
cp ./hosts-template "$hostpath"hosts


################
## Remplace variables with IP address

echo "Set IP addresses to:" $ip
sed -i -e "s/dynamicip/$ip/g" "$hostpath"hosts
echo "Done :)"
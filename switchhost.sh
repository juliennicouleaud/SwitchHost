#!/bin/bash

################################
## Configuration and file existence check
################################

hostpath="/etc/"

if [ ! -f "$hostpath"hosts ]; then
    echo "Warning : the file "$hostpath"hosts does not exist"
    exit
fi


################################
## Check if root
################################

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi


################################
## Read location and set IP
################################

echo "Where are you?"
echo "1. Home"
echo "2. Work"
echo "3. Bonnet"
echo "4. Mobile share"
echo "5. Host only"
echo "6. Temp"

read reponse
case $reponse in
    1 | home | Home) ip="192.168.1.62";;
    2 | work | Work) ip="192.168.35.165";;
    3 | bonnet | Bonnet) ip="192.168.1.17";;
    4 | mobile | Mobile | share | Share | "Mobile share" | "mobile share") ip="192.168.43.94";;
    5 | host | Host | "Host only" | "host only") ip="192.168.56.102";;
    6 | temp | Temp) ip="192.168.56.102";;
    *) echo "Erreur de saisie"
        exit 1;;
esac


################################
## Backup hosts file et remplace par le template
################################

echo "Backuping current host file"
if [ -f "$hostpath"hosts ]; then
    cp "$hostpath"hosts "$hostpath"hosts-backup-$(date +%y-%m-%d)--$(date +"%T")
    rm "$hostpath"hosts
else
    echo "Can't find hosts file under :" $hostpath
    exit
fi

echo "Replace current host file with template"
if [ -f ./hosts-template ]; then
    cp ./hosts-template "$hostpath"hosts
else
    echo "Can't find hosts-template file in current directory"
    exit
fi


################################
## Remplace variables with IP address
################################

echo "Setting IP addresses to:" $ip
if [ -f "$hostpath"hosts ]; then
    sed -i -e "s/dynamicip/$ip/g" "$hostpath"hosts
else
    echo "Can't find hosts file under :" $hostpath
    exit
fi
echo "Done :)"
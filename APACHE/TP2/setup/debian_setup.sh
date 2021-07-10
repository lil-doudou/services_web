#!/bin/bash

# Color
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

function docker_install()
{   
    apt update -y
    if [ $? == 1 ]
    then
        echo -e "${RED}Erreur lors de l'update du systeme${NC}"
        exit 0
    else
        echo -e "Update [ ${GREEN}OK${NC} ]"
    fi

    apt install docker.io
    if [ $? == 1 ]
    then
        echo -e "${RED}Erreur lors de l'installation de Docker${NC}"
        exit 0
    else
        echo -e "Install Docker [ ${GREEN}OK${NC} ]"
    fi
}

function tp2_environement_make()
 {
    mkdir -p ~/docker_partage/
    chmod 775 -R ~/docker_partage/
    # TO DO git clone the web site in TP1
    echo "Site web dans Docker OK" > ~/docker_partage/index.html
}

function start_web_site()
{
    docker run -it --rm -d -p 80:80 --name web -v /root/docker_partage/:/usr/share/nginx/html nginx 
}


### Start Script
echo "Configuration de l'hote"
echo "Interface de l'hote :"
read interface
echo "IP de l'hote :"
read address
echo "Masque de l'hote :"
read netmask
echo "Gateway de l'hote :"
read gateway
mv /etc/network/interfaces /etc/network/interfaces.old
sed 's/^/#/' /etc/network/interfaces.old >> /etc/network/interfaces
echo -e "
auto $interface
iface $interface inet static
    address $address
    netmask $netmask
    gateway $gateway
" >> /etc/network/interfaces
echo "Serveur DNS :"
read dns_server
mv /etc/resolv.conf /etc/resolv.conf.old
echo -e "nameserver $dns_server"


echo "Installation de Docker"
echo "Voulez vous lancer l'installation de Docker sur ce systeme ? [y;n]"
read validation
case $validation in 
    [Yy]*) docker_install 
            echo -e "${GREEN}Docker is installed${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled ${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}" 
            exit 0 ;;
esac

echo "Voulez vous créer un environement conforme a l'Atelier 2 ? [y;n]"
read validation
case $validation in 
    [Yy]*) tp2_environement_make 
            echo -e "${GREEN}TP2 environement is installed${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled ${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}"
            exit 0 ;;
esac

echo "Voulez vous lancer le site ? [y;n]"
read validation
case $validation in 
    [Yy]*) start_web_site
            echo -e "${GREEN}Site web is running${NC}";;
    [Nn]*) echo -e " ${ORANGE}Installation cancelled ${NC}"
            exit 1;;
    *) echo -e "${RED}Syntax error${NC}"
            exit 0 ;;
esac
#!/bin/bash/

# Passwords
ocpassw=admin
ocpassw=admin
rootpassw=root
# Get current adress
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
# The Welcome message
welcome_sh="/var/scripts/welcome.sh"

# Create welcome.sh and put that in ~/.profile
set -x
cat <<- WELCOME > "$welcome_sh"

clear 
echo "-------------------------------------------------------------------------"
echo "|    Welcome to ownCloud, your server is now ready!                       |"
echo "|                                                                 |"
echo "|    Please go to $ADRESS/owncloud to access your ownCloud        |"
echo "|    Your ownCloud admin account is: login: $ocuser passwd: $ocpassw              |"
echo "|    Your Linux root password is: $rootpassw                      |"
echo "|                                                                 |"
echo "|    More information in the documentation at: http://doc.owncloud.org/   |"
echo "|                                                                         |"
echo "-------------------------------------------------------------------------"

WELCOME

# Put welcome.sh in ~./profile
sed -i '$a bash /var/scripts/welcome.sh' /home/vagrant/.profile

exit 0


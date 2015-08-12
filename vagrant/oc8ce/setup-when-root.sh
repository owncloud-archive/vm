#!/bin/bash

# Need to fix:
# - ADRESS is showing wrong IP
# - Maybe combine this script with setup_when_root.sh?

echo scripts in /vagrant:
ls -la /vagrant
echo --------------------

# Passwords
ocuser=admin
ocpassw=admin
rootpassw=admin
# Get current address
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
# The Welcome message
welcome_sh="/var/scripts/welcome.sh"
mkdir -p /var/scripts

# Create welcome.sh and put that in ~/.profile
set -x
cat << WELCOME > "$welcome_sh"
#!/bin/bash
clear 
cat << EOM
---------------------------------------------------------------------------
|    Welcome to ownCloud, your server is now ready!                       |
|                                                                         |
|    Please go to $ADRESS/owncloud to access your ownCloud              |
|    Your ownCloud admin account is: login: $ocuser passwd: $ocpassw		  |
|    Your Linux root password is: $rootpassw					  |
|                                                                         |
|    More information in the documentation at: http://doc.owncloud.org/   |
|                                                                         |
|    To run the setup-script, please type: sudo -i, or login as root      |
---------------------------------------------------------------------------
EOM

WELCOME

# Put welcome.sh in ~/.profile
# REALLY?
# sed -i '$a bash /var/scripts/welcome.sh' /home/vagrant/.profile

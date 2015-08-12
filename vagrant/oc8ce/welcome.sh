#!/bin/bash

. /var/scripts/init-credentials

# Passwords
ocuser=$user
ocpassw=$password
rootpassw=$password
## Get current address
### How do we know it is called eth0?
# IFACE="eth0"
# IFCONFIG="/sbin/ifconfig"
# ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
ADDRESS=$(ip r | grep src | cut -d' ' -f12)

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
|    Please go to $ADDRESS/owncloud to access your ownCloud               |
|    Your ownCloud admin account is: login: $ocuser passwd: $ocpassw      |
|    Your Linux root password is: $rootpassw                              |
|                                                                         |
|    More information in the documentation at: http://doc.owncloud.org/   |
|                                                                         |
|    To run the setup-script, please type: sudo -i, or login as root      |
---------------------------------------------------------------------------
EOM

WELCOME

# Put welcome.sh in ~/.profile
sed -i '$a bash /var/scripts/welcome.sh' /home/vagrant/.profile

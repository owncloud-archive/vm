#!/bin/bash
#
## Tech and Me ## - 2015, https://www.en0ch.se/about-me
#

# Check if root
if [ "$(whoami)" != "root" ]; then
        echo
        echo -e "\e[31mSorry, you are not root.\n\e[0mYou must type: \e[36msudo \e[0mbash /var/scripts/owncloud-startup-script.sh"
        echo
        exit 1
fi
clear &&
echo "----------------------------------------------------------------------"
echo "| This script will configure your ownCloud and activate SSL.         |"
echo "| It will also do the following:                                     |"
echo "|                                                                    |"
echo "| - Activate a Virtual Host for your ownCloud install                |"
echo "| - Install Webmin                                                   |"
echo "| - Upgrade your system to latest version                            |"
echo "| - Set secure permissions to ownCloud                               |"
echo "| - Set new passwords to Ubuntu Server and ownCloud                  |"
echo "| - Set new keyboard layout                                          |"
echo "| - Change timezone                                                  |"
echo "| - Install SMB-client to be able to mount external storages         |"
echo "| - Set static IP to the system (you have to set the same IP in      |"
echo "|   your router) https://www.en0ch.se/open-port-80-443/              |"
echo "|                                                                    |"
echo "|   The script will take about 5 minutes to finish                   |"
echo "|   depending on your internet connection                            |"
echo "|                                                                    |"
echo "| ####################### Tech and Me - 2015 ####################### |"
echo "----------------------------------------------------------------------"
echo -e "\e[32m"
read -p "Press any key to start the script..." -n1 -s
clear
echo -e "\e[0m"
# Activate self-signed SSL
a2enmod ssl
a2enmod headers
a2dissite default-ssl
a2ensite owncloud-self-signed-ssl.conf
service apache2 reload

# Install packages for Webmin
apt-get install --force-yes -y zip perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python

# Install Webmin
sed -i '$a deb http://download.webmin.com/download/repository sarge contrib' /etc/apt/sources.list
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
apt-get update
apt-get install --force-yes -y webmin

# Install SMB-client
apt-get install smbclient --force-yes -y
clear

# Set keyboard layout
echo "Current keyboard layout is Swedish"
echo "You must change keyboard layout to your language"
echo -e "\e[32m"
read -p "Press any key to change keyboard layout... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure keyboard-configuration &&
echo
clear

# Change Timezone
echo "Current Timezone is Swedish"
echo "You must change timezone to your timezone"
echo -e "\e[32m"
read -p "Press any key to change timezone... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure tzdata
echo
sleep 3
clear

# Change IP
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
echo -e "\e[0m"
echo "The script will now configure your IP to be static."
echo -e "\e[36m"
echo -e "\e[1m"
echo "Your internal IP is: $ADDRESS"
echo -e "\e[0m"
echo -e "Write this down, you will need it to set static IP"
echo -e "in your router later. It's included in this guide:"
echo -e "https://www.en0ch.se/open-port-80-443/ (step 1 - 5)"
echo -e "\e[32m"
read -p "Press any key to set static IP..." -n1 -s
clear
echo -e "\e[0m"
ifdown eth0
sleep 2
ifup eth0
sleep 2
bash /var/scripts/ip.sh
ifdown eth0
sleep 2
ifup eth0
sleep 2
echo
echo "Testing if network is OK..."
sleep 1
echo
bash /var/scripts/test_connection.sh
sleep 2
echo
echo -e "\e[0mIf the output is \e[32mConnected! \o/\e[0m everything is working."
echo -e "\e[0mIf the output is \e[31mNot Connected!\e[0m you should change\nyour settings manually in the next step."
echo -e "\e[32m"
read -p "Press any key to open /etc/network/interfaces..." -n1 -s
echo -e "\e[0m"
nano /etc/network/interfaces
clear &&
echo "Testing if network is OK..."
ifdown eth0
sleep 2
ifup eth0
sleep 2
echo
bash /var/scripts/test_connection.sh
sleep 2
clear

# Change Trusted Domain and CLI
bash /var/scripts/trusted.sh

# Change password
echo -e "\e[0m"
echo "For better security, change the Linux password for [ocadmin]"
echo "The current password is [owncloud]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
sudo passwd ocadmin
echo
clear &&
echo -e "\e[0m"
echo "For better security, change the ownCloud password for [ocadmin]"
echo "The current password is [owncloud]"
echo -e "\e[32m"
read -p "Press any key to change password for ownCloud... " -n1 -s
echo -e "\e[0m"
sudo -u www-data php /var/www/owncloud/occ user:resetpassword ocadmin
echo

# System Upgrade
bash /var/scripts/owncloud_update.sh

# Cleanup 1
apt-get autoremove -y
CLEARBOOT=$(dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | xargs sudo apt-get -y purge)
echo "$CLEARBOOT"
clear

# Success!
echo -e "\e[32m"
echo    "----------------------------------------------------------------------"
echo    "| You have sucessfully installed ownCloud! System will now reboot... |"
echo    "|                                                                    |"
echo -e "|         \e[0mLogin to ownCloud in your browser:\e[36m" $ADDRESS"\e[32m           |"
echo    "|                                                                    |"
echo -e "|         \e[0mPublish your server online! \e[36mhttp://goo.gl/H7IsHm\e[32m           |"
echo    "|                                                                    |"
echo -e "|    \e[91m#################### Tech and Me - 2015 ####################\e[32m    |"
echo    "----------------------------------------------------------------------"
echo
read -p "Press any key to reboot..." -n1 -s
echo -e "\e[0m"
echo

# Cleanup 2
sudo -u www-data php /var/www/owncloud/occ maintenance:repair
rm /var/scripts/owncloud-startup-script.sh
rm /var/scripts/ip.sh
rm /var/scripts/trusted.sh
rm /var/scripts/test_connection.sh
rm /var/www/owncloud/data/owncloud.log
cat /dev/null > ~/.bash_history
cat /dev/null > /var/spool/mail/root
cat /dev/null > /var/spool/mail/ocadmin

## Reboot
reboot
exit 0


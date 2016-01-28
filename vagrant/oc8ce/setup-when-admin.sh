#!/bin/bash
clear

cat << EOMSTART
+---------------------------------------------------------------+
|   This script will do the final setup for you                 |
|                                                               |
|   - Change keyboard setup (current is US)                     |
|   - Change timezone                                           |
|   - Set new passwords to Ubuntu and ownCloud (user: admin)    |
|                                                               |
| +++ To access the shell immediately, please press crtl+c +++  |
+---------------------------------------------------------------+

EOMSTART
echo
echo -e "\e[32m"
echo The script will begin in 10 seconds...
echo -e "\e[0m"
sleep 10
clear

# Set keyboard layout
echo "Current keyboard layout is US"
echo "You must change keyboard layout to your language"
echo -e "\e[32m"
read -p "Press any key to change keyboard layout... " -n1 -s
echo -e "\e[0m"
sudo dpkg-reconfigure keyboard-configuration 
echo
clear

# Change Timezone
echo "Current Timezone is UTC"
echo "You must change timezone to your timezone"
echo -e "\e[32m"
read -p "Press any key to change timezone... " -n1 -s
echo -e "\e[0m"
sudo dpkg-reconfigure tzdata
echo
sleep 3
clear

# Change password
sudo bash /var/scripts/change_pass_admin.sh

echo -e "\e[0m"
echo "For better security, change the ownCloud password for [admin]"
echo -e "\e[32m"
read -p "Press any key to change ownCloud password ... " -n1 -s
echo -e "\e[0m"
sudo -u www-data php /var/www/owncloud/occ user:resetpassword admin
echo
if [[ $? > 0 ]]
then
    sudo -u www-data php /var/www/html/owncloud/occ user:resetpassword admin
else
    sleep 2
fi
sleep 2
clear

cat << EOMFINISH

+-------------------------------------------------+
|   Success! You have now done the final setup.   |
|   The system is now ready ...                   |
+-------------------------------------------------+

EOMFINISH

echo -e "\e[32m"
read -p $'\x0aPress any key to return to the shell prompt.\x0aType "exit" there, to go back to the login prompt. \x0aIf you want to become root, type "sudo -i" ...\x0a' -n1 -s
echo -e "\e[0m"
clear
exit 0

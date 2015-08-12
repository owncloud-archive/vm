 #!/bin/bash
 clear 
-cat << EOMSTART
 +---------------------------------------------------------------+
-|   This script will do the final setup for you                 |
-|                                                               |                                                                    
-|   - Change keyboard setup (current is US)                     |                                                                 
-|   - Change timezone                                           |                                                                 
-|   - Set new passwords to xUbuntu and ownCloud (user: $user)   |                                                                 
-|   - Activate Self-signed SSL (self-signed-ssl.conf)           |
 +---------------------------------------------------------------+
-
-The script will begin in 10 seconds...
-EOMSTART
-sleep 10
-clear
-
-# Set keyboard layout
-echo "Current keyboard layout is US"
-echo "You must change keyboard layout to your language"
-echo -e "\e[32m"
-read -p "Press any key to change keyboard layout... " -n1 -s
-echo -e "\e[0m"
-sudo dpkg-reconfigure keyboard-configuration 
-echo
-clear
-
-# Change Timezone
-echo "Current Timezone is UTC"
-echo "You must change timezone to your timezone"
-echo -e "\e[32m"
-read -p "Press any key to change timezone... " -n1 -s
-echo -e "\e[0m"
-sudo dpkg-reconfigure tzdata
-echo
-sleep 3
-clear
-
-# Change password
-echo -e "\e[0m"
-echo "For better security, change the Ubuntu password for [$user]"
-echo "The current password is [$password]"
-echo -e "\e[32m"
-read -p "Press any key to change password for Ubuntu... " -n1 -s
-echo -e "\e[0m"
-sudo passwd $user
-echo
-clear 

echo -e "\e[0m"
echo "For better security, change the ownCloud password for [$user]"
echo "The current password is [$password]"
echo -e "\e[32m"
read -p "Press any key to change password for ownCloud... " -n1 -s
echo -e "\e[0m"
sudo -u www-data php /var/www/owncloud/occ user:resetpassword $password
echo
-
-cat << EOMFINISH
-
 +-------------------------------------------------+
-|   Success! You have now done the final setup.   |
-|   The system will now reboot...                 |
 +-------------------------------------------------+
-
-EOMFINISH
-sleep 4
-# Remove the script so that it won't run every time the user becomes root
-sudo rm /var/scripts/setup-when-root.sh
-
-# Reboot
-read -p "Press any key to reboot..." -n1 -s
-echo -e "\e[0m"
-echo
-sudo reboot

exit 0

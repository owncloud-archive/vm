#!/bin/bash

setup-when-root_sh="/var/scripts/setup-when-root.sh"

echo scripts in /vagrant:
ls -la /vagrant
echo --------------------


# Create setup-when-root.sh and put that in /root/.profile
set -x
cat << SETUP > "$setup-when-root_sh"
#!/bin/bash
clear 
cat << EOMSTART
-----------------------------------------------------------------
|   This script will do the final setup for you                 |
|                                                               |                                                                    
|   - Change keyboard setup                                     |                                                                 
|   - Change timezone                                           |                                                                 
|   - Set new passwords to xUbuntu (Vagrant user) and ownCloud  |                                                                 
|   - Activate a Virtual Host for your ownCloud install         |                                                                 
|   - Activate Self-signed SSL (self-signed-ssl.conf)           |
-----------------------------------------------------------------

The script will begin in 10 seconds...
EOMSTART
sleep 10

# Set keyboard layout
echo "Current keyboard layout is US"
echo "You must change keyboard layout to your language"
echo -e "\e[32m"
read -p "Press any key to change keyboard layout... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure keyboard-configuration 
echo
clear

# Change Timezone
echo "Current Timezone is US"
echo "You must change timezone to your timezone"
echo -e "\e[32m"
read -p "Press any key to change timezone... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure tzdata
echo
sleep 3
clear

# Change password
echo -e "\e[0m"
echo "For better security, change the Ubuntu password for [vagrant]"
echo "The current password is [vagrant]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
sudo passwd admin
echo
clear 
echo -e "\e[0m"
echo "For better security, change the ownCloud password for [admin]"
echo "The current password is [admin]"
echo -e "\e[32m"
read -p "Press any key to change password for ownCloud... " -n1 -s
echo -e "\e[0m"
sudo -u www-data php /var/www/owncloud/occ user:resetpassword admin
sleep 2
clear

# Set secure permissions
# We have to create this during the build:
bash /var/scripts/secure-permissions.sh

cat << EOMFINISH

---------------------------------------------------
|   Success! You have now done the final setup.   |
|   The system will now reboot...                 |
---------------------------------------------------

EOMFINISH
sleep 4

# Reboot
read -p "Press any key to reboot..." -n1 -s
echo -e "\e[0m"
echo
reboot

SETUP

# Put welcome.sh in /root/.profile 
## (is the if arguments even possible to put in like this?)
## looks complicated to me. Can't we simplify that?
#sed -i '$a bash if [ -x /var/scripts/setup-when-root.sh ]; then' /root/.profile
#sed -i '$a /var/scripts/setup-when-root.sh' /root/.profile
#sed -i '$a fi' /root/.profile
cat >> /root/.profile <<'INIT'
 if [ -x /var/scripts/welcome.sh]; then
   bash /var/scripts/welcome.sh
 fi
INIT

## RM the script so that it's not run every time the user becomes root.
# rm /var/scripts/setup-when-root.sh
rm $0

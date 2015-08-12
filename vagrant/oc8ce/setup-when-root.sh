#!/bin/bash

setup_when_root_sh="/var/scripts/setup-when-root.sh"

# Create setup-when-root.sh and put that in /root/.profile
set -x
cat << SETUP > "$setup_when_root_sh"
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
clear

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
echo "Current Timezone is UTC"
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
sudo passwd vagrant
echo
clear 

cat << EOMFINISH

---------------------------------------------------
|   Success! You have now done the final setup.   |
|   The system will now reboot...                 |
---------------------------------------------------

EOMFINISH
sleep 4
# Remove the script so that it won't run every time the user becomes root
rm /var/scripts/setup-when-root.sh

# Reboot
read -p "Press any key to reboot..." -n1 -s
echo -e "\e[0m"
echo
reboot

SETUP

# Put setup-when-root in /root/.profile 
cat >> /root/.profile <<'INIT'
 if [ -x /var/scripts/setup-when-root.sh ]; then
    bash /var/scripts/setup-when-root.sh
 fi
INIT

# This deletes the file from the vagrant folder. Not intended. Moved it --^
# rm /var/scripts/setup-when-root.sh
# rm $0

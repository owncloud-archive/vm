#!/bin/bash
#
## Tech and Me ## - 2015, https://www.en0ch.se/
#

# Cleanup unused packages
apt-get autoremove -y 
apt-get autoclean 

# System Upgrade
apt-get update 
aptitude full-upgrade -y 
sudo -u www-data php /var/www/owncloud/occ upgrade

# Enable Apps
sudo -u www-data php /var/www/owncloud/occ app:enable mail
sudo -u www-data php /var/www/owncloud/occ app:enable calendar
sudo -u www-data php /var/www/owncloud/occ app:enable contacts
sudo -u www-data php /var/www/owncloud/occ app:enable documents
sudo -u www-data php /var/www/owncloud/occ app:enable galleryplus
sudo -u www-data php /var/www/owncloud/occ app:disable gallery
sudo -u www-data php /var/www/owncloud/occ app:enable external

# Set secure permissions to ownCloud
bash /var/scripts/setup_secure_permissions_owncloud.sh

# Write to log
echo "OWNCLOUD UPDATE success-`date +"%Y%m%d"`  " >> /var/log/cronjobs_success.log

# Un-hash this if you want automatic reboots:
# sudo reboot

exit 0

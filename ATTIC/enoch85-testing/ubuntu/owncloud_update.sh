#!/bin/bash
#
## Tech and Me ## - 2015, https://www.techandme.se/
#

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

# Increase max filesize (this expects that changes are made to php.ini already)
FILENAME="# php_value upload_max_filesize 513M"

if grep -Fxq "$FILENAME" /var/www/owncloud/.htaccess
then
        exit 1
else
        sed -i 's/php_value upload_max_filesize 513M/# php_value upload_max_filesize 513M/g' /var/www/owncloud/.htaccess
        sed -i 's/php_value post_max_size 513M/# php_value post_max_size 513M/g' /var/www/owncloud/.htaccess
        sed -i 's/php_value memory_limit 512M/# php_value memory_limit 512M/g' /var/www/owncloud/.htaccess
fi


# Set secure permissions to ownCloud
bash /var/scripts/setup_secure_permissions_owncloud.sh

# Cleanup unused packages
apt-get autoremove -y 
apt-get autoclean

# Write to log
echo "OWNCLOUD UPDATE success-`date +"%Y%m%d"`  " >> /var/log/cronjobs_success.log

# Un-hash this if you want automatic reboots:
# sudo reboot

exit 0

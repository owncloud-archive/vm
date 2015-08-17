#!/bin/bash
#
# check-init.sh
# 
# Done here, if owncloud is found uninitialized:
# * generate random password, 
# * change password of owncloud and admin shell users.
# * initialize owncloud.
# * set secure permissions
# * rm owncloud.log for clean logs
# * Enable GalleryPlus, Documents, and Mail

exec 3>&1 1>>/var/log/check-init.log 2>&1

mysql_pass=admin	# KEEP in sync with build-ubuntu-vm.sh
cred_file=/var/scripts/init-credentials.sh
oc=/var/www/owncloud

# initialize owncloud and populate $cred_file (only on firstboot...)
if (sudo -u www-data php $oc/occ status 2>&1 | grep -q ' is not installed '); then

  # Not a strong password, but easy to learn, than makepasswd output. bashism!
  # Do not use y or z, to help with keyboard mismatch.
  # Do not use l, to avoid confusion with 1.
  password=$(shuf -e {a..x}{0..9} | tr l e | head -n 5 | tr -d '\n')

  echo Your new admin password will be $password | tee /dev/fd/3
  echo -e "root:$password\nadmin:$password\nowncloud:$password" | chpasswd
  echo -e "user=admin\npassword=$password" > $cred_file

  # poor man's occ install. Use occ install instead, if no 8.0 or before compatibility needed.
  curl -s --data "install=true&adminpass=$password&adminlogin=admin&dbuser=root&dbtype=mysql&dbpass=admin&dbname=oc&dbhost=localhost" localhost:80/owncloud/index.php/settings/index.php

  # check now.
  sudo -u www-data php $oc/occ status
fi

# set servername directive to avoid warning about fully qualified domain name when apache restarts
# working fix, but https://github.com/owncloud/vm/issues/6#issuecomment-131079431
    # sed -i 's/127.0.0.1 localhost/127.0.0.1 localhost.localdomain vagrant-ubuntu-trusty-64/g' /etc/hosts

# Enable the apps we want the user to have
    # Disable gallery, and enable GalleryPlus
    sudo -u www-data php /var/www/owncloud/occ app:disable gallery
    sudo -u www-data php /var/www/owncloud/occ app:enable galleryplus

    # Enable Mail
    sudo -u www-data php /var/www/owncloud/occ app:enable mail
    php /var/scripts/update-config.php $oc/config/config.php 'app.mail.server-side-cache.enabled' 'true'

    # Enable Documents
    sudo -u www-data php /var/www/owncloud/occ app:enable documents
    php /var/scripts/update-config.php $oc/config/config.php 'preview_libreoffice_path' '/usr/bin/libreoffice'

## install memcache
# check if a decent apt-get install php5-apcu was done at build time!
if [ 0$(php -r 'print(version_compare("4.0.6",phpversion("apc"),"<="));'
) -eq 1 ]; then
  php /var/scripts/update-config.php $oc/config/config.php 'memcache.local' '\OC\Memcache\APCu'
  # keep occ happy.
  echo 'apc.enable_cli = 1' >> /etc/php5/cli/php.ini

  # statistics tool.
  test -f /usr/share/php5/apcu/apc.php && cp /usr/share/php5/apcu/apc.php /var/www/owncloud
  test -f /var/www/owncloud/apc.php && chmod a+x /var/www/owncloud/apc.php
fi

## list of all addresses in case it is a multihomed host.
declare -a ADDRESSES=($(ip r | grep src | cut -d' ' -f12))

## one address to rule them all, or something ...
GATEWAY=$(ip r | grep default | sed -e 's@.* dev \(\S\S*\) .*@\1@')
ADDRESS=$(ip r | grep ${GATEWAY:-src} | grep src | head -n 1 | cut -d' ' -f12)

## set trusted domain
php /var/scripts/update-config.php $oc/config/config.php 'trusted_domains[]' localhost ${ADDRESSES[@]} $(hostname) $(hostname --fqdn)
php /var/scripts/update-config.php $oc/config/config.php overwrite.cli.url https://$ADDRESS/owncloud

# set secure permissions
bash /var/scripts/secure-permissions.sh

# we want clean logs
rm $oc/data/owncloud.log

# Prepare /etc/issue and /etc/motd with hints.
# Hint: Disable this by erasing $cred_file after changing the password.
if [ -f $cred_file ]; then 
  . $cred_file
  ocVersion=$(head -n1 /var/www/owncloud/.htaccess)
  test -f /etc/issue.orig || mv /etc/issue /etc/issue.orig
  figlet -m2 "$ADDRESS" | sed -e 's@\\@\\\\@g' > /etc/issue
  cat >> /etc/issue << ISSUE
Ubuntu 14.04.2 LTS \n \l

+---------------------------------------------------------+
|                                                         |
| Welcome to ownCloud!                 $ocVersion   |
|                                                         |
|  This server is reachable at https://$ADDRESS/owncloud |
|  Initial admin login:    $user                          |
|  Initial admin password: $password                     |
+---------------------------------------------------------+

Please log in here at the prompt as 'admin' 
and follow the instructions to change the defaults.
If something goes wrong, just log in as admin again
and the script will be executed again.

ISSUE
fi

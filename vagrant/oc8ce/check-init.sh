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

exec 3>&1 1>>/var/log/check-init.log 2>&1

mysql_pass=admin	# KEEP in sync with build-ubuntu-vm.sh
cred_file=/var/scripts/init-credentials.sh
oc=/var/www/owncloud

# initialize owncloud and populate $cred_file (only on firstboot...)
if (sudo -u www-data php $oc/occ status 2>&1 | grep -q ' is not installed '); then

  # not a strong password, but easy to learn, than makepasswd output. bashism!
  password=$(shuf -e {a..z}{0..9} | head -n 5 | tr -d '\n')

  echo Your new admin password will be $password | tee /dev/fd/3
  echo -e "root:$password\nadmin:$password\nowncloud:$password" | chpasswd
  echo -e "user=admin\npassword=$password" > $cred_file

  # poor man's occ install. Use occ install instead, if no 8.0 or before compatibility needed.
  curl --data "install=true&adminpass=$password&adminlogin=admin&dbuser=root&dbtype=mysql&dbpass=admin&dbname=oc&dbhost=localhost" localhost:80/owncloud/index.php/settings/index.php

  # check now.
  sudo -u www-data php $oc/occ status
fi

# set secure permissions
bash /var/scripts/secure-permissions.sh

# we want clean logs
rm $oc/data/owncloud.log

## install memcahed
# check if apt-get install php5-apcu was done at build time!
php -m | grep -q apcu && php /var/scripts/update-config.php $oc/config/config.php 'memcache.local' '\\OC\\Memcache\\APCu'

## list of all addresses in case it is a multihomed host.
declare -a ADDRESSES=($(ip r | grep src | cut -d' ' -f12))

## one address to rule them all, or something ...
GATEWAY=$(ip r | grep default | sed -e 's@.* dev \(\S\S*\) .*@\1@')
ADDRESS=$(ip r | grep ${GATEWAY:-src} | grep src | head -n 1 | cut -d' ' -f12)

## set trusted domain
php /var/scripts/update-config.php $oc/config/config.php 'trusted_domains[]' localhost ${ADDRESSES[@]} $(hostname) $(hostname --fqdn)
php /var/scripts/update-config.php $oc/config/config.php overwrite.cli.url https://$ADDRESS/owncloud

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

ISSUE
fi

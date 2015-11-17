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

#exec 3>&1 1>>/var/log/check-init.log 2>&1

mysql_pass=admin	# KEEP in sync with build-ubuntu-vm.sh
cred_file_dir=/var/scripts/www
cred_file=$cred_file_dir/init-credentials.sh
oc=/var/www/owncloud

# initialize owncloud and populate $cred_file (only on firstboot...)
if (sudo -u www-data php $oc/occ status 2>&1 | grep -q ' is not installed '); then

  # Not a strong password, but easy to learn, than makepasswd output. bashism!
  # Do not use y or z, to help with keyboard mismatch.
  # Do not use l, to avoid confusion with 1.
  password=$(shuf -e {a..x}{0..9} | tr l e | head -n 5 | tr -d '\n')
  instanceid=oc$(shuf -e {0..9}{a..z} | tr l e | head -n 5 | tr -d '\n')

  php /var/scripts/update-config.php $oc/config/config.php instanceid $instanceid

  mkdir -p $cred_file_dir
  chown www-data $cred_file_dir
  chmod 775 $cred_file_dir

  echo Your new admin password will be $password | tee /dev/fd/3
  echo -e "root:$password\nadmin:$password\nowncloud:$password" | chpasswd
  echo -e "user=admin\npassword=$password" > $cred_file

  # poor man's occ install. Use occ install instead, if no 8.0 or before compatibility needed.
  curl -s --data "install=true&adminpass=$password&adminlogin=admin&dbuser=root&dbtype=mysql&dbpass=admin&dbname=oc&dbhost=localhost" localhost:80/owncloud/index.php/settings/index.php

  # check now.
  sudo -u www-data php $oc/occ status
fi

# Enable the apps we want the user to have
  bash /var/scripts/install-additional-apps.sh enable

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

## set trusted domain on first boot, then delete the script.
FILE="/var/scripts/set-trusted-domain.sh"
if [ -f $FILE ];
then
        bash /var/scripts/set-trusted-domain.sh
        rm /var/scripts/set-trusted-domain.sh
else
        echo "Trusted domain is already set"
fi

# set secure permissions
bash /var/scripts/secure-permissions.sh

# we want clean logs
rm $oc/data/owncloud.log

# Prepare /etc/issue and /etc/motd with hints.
# Hint: Disable this by erasing $cred_file after changing the password.
if [ -s $cred_file ]; then 
  . $cred_file
  ocVersion=$(head -n1 /var/www/owncloud/.htaccess)
  test -f /etc/issue.orig || mv /etc/issue /etc/issue.orig
  vers20=$(printf "%-20s" "$ocVersion")
  addr40=$(printf "%-40s" "https://$ADDRESS/owncloud")
  user40=$(printf "%-40s" "$user")
  pass40=$(printf "%-40s" "$password")
  cat > /etc/issue << ISSUE
          Ubuntu 14.04.2 LTS \n \l

    +----------------------------------------------------------------------+
    |                                                                      |
    |           Welcome to ownCloud!          $vers20         |
    |                                                                      |
    |  This server is reachable at $addr40|
    |  Initial admin login:    $user40    |
    |  Initial admin password: $pass40    |
    +----------------------------------------------------------------------+
    |  If the virtual machine is run with NAT, please review the port      |
    |  forwarding of the network adapter, or try http://localhost:8888     |
    +----------------------------------------------------------------------+
    |   You can now logon to your ownCloud by using the ip-address from    |
    |   above with your web browser. Please import the SSL cert to your    |
    |   browser, or accept the security warning to connect to your         |
    |   ownCloud via HTTPS.                                                |
    +----------------------------------------------------------------------+
    |   OPTIONAL:                                                          |
    |   If you want to do the final setup (e.g. change admin password),    |
    |   please log in as user 'admin' to run the setup-script.             |
    +----------------------------------------------------------------------+
ISSUE
fi

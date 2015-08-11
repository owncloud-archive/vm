#!/bin/sh
#
# check-init.sh
# 
# TODO here: 
# * generate random password, 
# * change password of owncloud and admin shell users.
# * initialize owncloud.

mysql_pass=admin	# KEEP in sync with build-ubuntu-vm.sh

# do nothing if owncloud is already initialized.
sudo -u www-data php /var/www/owncloud/occ status 2>&1 | grep -q ' is not installed ' || exit 0 # already done

# not a strong password, but easy to learn.
password=$(shuf -e {a..z}{0..9} | head -n 5 | tr -d '\n')

echo your password will be $password
echo -e "$password\n$password" | sudo passwd admin 2> /dev/null
echo -e "$password\n$password" | sudo passwd owncloud 2> /dev/null

# poor man's occ install. Use occ install instead, if no 8.0 or before compatibility needed.
curl --data "install=true&adminpass=$password&adminlogin=admin&dbuser=root&dbtype=mysql&dbpass=admin&dbname=oc&dbhost=localhost" localhost:80/owncloud/index.php/settings/index.php


# check now.
sudo -u www-data php /var/www/owncloud/occ status

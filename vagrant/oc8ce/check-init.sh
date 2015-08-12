#!/bin/sh
#
# check-init.sh
# 
# Done here, if owncloud is found uninitialized:
# * generate random password, 
# * change password of owncloud and admin shell users.
# * initialize owncloud.

exec 3>&1 1>>/var/log/check-init.log 2>&1

mysql_pass=admin	# KEEP in sync with build-ubuntu-vm.sh
cred_file=/var/scripts/init-credentials.sh

# initialize owncloud and populate $cred_file (only on firstboot...)
if (sudo -u www-data php /var/www/owncloud/occ status 2>&1 | grep -q ' is not installed '); then

  # not a strong password, but easy to learn, than makepasswd output. bashism!
  password=$(bash -c 'shuf -e {a..z}{0..9}' | head -n 5 | tr -d '\n')

  echo your password will be $password | tee /dev/fd/3
  /bin/echo -e "root:$password\nadmin:$password\nowncloud:$password" | sudo chpasswd
  /bin/echo -e "user=admin\npassword=$password" > $cred_file

  # poor man's occ install. Use occ install instead, if no 8.0 or before compatibility needed.
  curl --data "install=true&adminpass=$password&adminlogin=admin&dbuser=root&dbtype=mysql&dbpass=admin&dbname=oc&dbhost=localhost" localhost:80/owncloud/index.php/settings/index.php

  # check now.
  sudo -u www-data php /var/www/owncloud/occ status
fi

# Prepare /etc/issue and /etc/motd with hints.
# Hint: Disable this by erasing $cred_file after changing the password.
if [ -f $cred_file ]; then 
  . $cred_file
  ADDRESS=$(ip r | grep src | cut -d' ' -f12)
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

Please log in here at the shell prompt as 'admin' 
and follow the instructions to change the defaults.

ISSUE
fi

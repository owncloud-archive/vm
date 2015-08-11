#!/bin/sh
#
# check-init.sh
# 

# do nothing if owncloud is already initialized.
php /var/ww/owncloud/occ status 2>&1 | grep -q ' is not installed ' || exit 0 # already done

# TODO here: 
# * generate random password, 
# * change password of owncloud and admin shell users.
# * initialize 

password=$(shuf -e {a..z}{0..9} | head -n 5 | tr -d '\n')

echo your password will be $password

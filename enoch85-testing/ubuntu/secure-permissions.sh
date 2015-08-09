#!/bin/bash
ocpath='/var/www/owncloud'
htuser='www-data'

find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

chown -R root:${htuser} ${ocpath}/
chown -R ${htuser}:${htuser} ${ocpath}/apps/
chown -R ${htuser}:${htuser} ${ocpath}/config/
chown -R ${htuser}:${htuser} ${ocpath}/data/

chown root:${htuser} ${ocpath}/.htaccess
chown root:${htuser} ${ocpath}/data/.htaccess

chmod 0644 ${ocpath}/.htaccess
chmod 0644 ${ocpath}/data/.htaccess

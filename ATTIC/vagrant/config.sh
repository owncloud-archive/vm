#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : ownCloud Appliance
# COPYRIGHT     : (c) 2014,2015 ownCloud.com - GPLv2 - All rights reserved
#               :
# AUTHOR        : Jürgen Weigert <jw@owncloud.com>
#               :
# BELONGS TO    : Community Appliances
#               :
#----------------
#======================================
# Firewall Configuration
#--------------------------------------
echo '** Configuring firewall...'
chkconfig SuSEfirewall2_init on
chkconfig SuSEfirewall2_setup on

sed --in-place -e 's/# solver.onlyRequires.*/solver.onlyRequires = true/' /etc/zypp/zypp.conf

# Enable sshd
chkconfig sshd on

#======================================
# baseUpdateSysConfig
#--------------------------------------
function baseUpdateSysConfig {
        # /.../
        # Update sysconfig variable contents
        # ----
        local FILE=$1
        local VAR=$2
        local VAL=$3
        local args=$(echo "s'@^\($VAR=\).*\$@\1\\\"$VAL\\\"@'")
        eval sed -i $args $FILE
}


#======================================
# Sysconfig Update
#--------------------------------------
echo '** Update sysconfig entries...'
baseUpdateSysConfig /etc/sysconfig/keyboard KEYTABLE us.map.gz
baseUpdateSysConfig /etc/sysconfig/network/config FIREWALL yes
baseUpdateSysConfig /etc/init.d/suse_studio_firstboot NETWORKMANAGER no
baseUpdateSysConfig /etc/sysconfig/SuSEfirewall2 FW_SERVICES_EXT_TCP 22\ 80\ 443
baseUpdateSysConfig /etc/sysconfig/console CONSOLE_FONT lat9w-16.psfu


#======================================

cat >> /etc/init.d/boot.local << EOF0
echo $displayname $version
echo ""
echo "IP Address: \$(ip r | grep src | cut -d' ' -f12)"
EOF0

cat > /etc/issue <<EOF3


Welcome to ownCloud!
$displayname $version

Please log in as user 'root' with the password 'admin'!

EOF3

cat > /etc/issue.orig <<EOF4
This server is reachable at  https://$(ip r | grep src | cut -d' ' -f12)/owncloud

Welcome to ownCloud!
$displayname $version

Please log in as user 'root'!

EOF4

#======================================
set -x
# TEST: is this what causes the great pause?
# plymouth-set-default-theme text -R
#echo >> /usr/lib/systemd/system/dbus.service "Before=basic.target"

# CAUTION: Keep in sync with root/bin/start -- it moves
#          both /etc/*.orig files away when succeded once.
cat >> /etc/profile.d/profile.sh << EOF1
if test "\$SHLVL" == "1"; then
  test -x /usr/bin/landscape-sysinfo && /usr/bin/landscape-sysinfo
  echo ""
  if [ -f /etc/issue.orig -o -f /etc/motd.orig ]; then
    echo ">>> Please type 'start' to begin. <<<"
  fi
fi
EOF1


#======================================
# Setting up overlay files 
#--------------------------------------
echo '** Setting up overlay files...'
set -x
destdir=/srv/www/htdocs/owncloud
ls -la $destdir


chown root:root /root/bin/*
chmod 755 /root/bin/*


chown root:root /etc/logrotate.d/owncloud
chmod 644 /etc/logrotate.d/owncloud


chown root:root /root/README
chmod 644 /root/README

chown -R wwwrun:www /srv/www
chmod -R u+w /srv/www

chown root:root /var/spool/cron/tabs/wwwrun
chmod 600 /var/spool/cron/tabs/wwwrun


#======================================
# Configure MySQL database
#--------------------------------------

# Helper function to wait 30s for MySQL socket to appear.
wait_for_socket() {
  local i
  for((i=0; i<150; i++)); do
    sleep 0.2
    test -S $1 && i='' && break
  done
  test -z "$i" || return 1
  return 0
}

# Helper function to execute the given sql file.
execute_sql_file() {
  local socket=$1
  local sql_file=$2
  mysql --socket="$socket" -u root < "$sql_file" 2>&1
}

# Setting /tmp to 777 with sticky bit for mysql_install_db to work properly
# Fix for BUG 815284
echo "## Setting /tmp to 777 with sticky bit..."
chmod a+trwx /tmp

# Initialize MySQL
echo "## Initializing MySQL databases and tables..."
mysql_install_db #--user=mysql

chown -R mysql:mysql /var/lib/mysql #======================Changed Mysql Rights====================#

# Start MySQL without networking
echo "## Starting MySQL..."
mkdir -p /var/log/mysql/
socket=/var/run/mysql/mysql.sock
mysqld_safe --skip-networking --pid-file=/tmp/mysqld.pid --socket=$socket & # --user=mysql
wait_for_socket $socket || {
  echo "## Error: $socket didn't appear within 30 seconds"
}

# Load MySQL data dump, if it exists
mysql_dump=/tmp/mysql_dump.sql
if [ -f "$mysql_dump" ]; then
  echo "## Loading MySQL data dump..."
  execute_sql_file "$socket" "$mysql_dump"
else
  echo "## No MySQL data dump found, skipping"
fi

# Load MySQL users and permissions, if setup file exists
mysql_perms=/tmp/mysql_config.sql
if [ -f "$mysql_perms" ]; then
  echo "## Loading MySQL users and perms..."
  execute_sql_file "$socket" "$mysql_perms"
else
  echo "## No MySQL user/perms config found, skipping"
fi

# Auto-start MySQL
echo "## Configuring MySQL to auto-start on boot..."
chkconfig mysql on

# Stop MySQL service (for uncontained builds)
echo "## Stopping MySQL..."
mysql_pid=/tmp/mysqld.pid
kill -TERM `cat $mysql_pid`

# Clean up temp files (for uncontained builds)
rm -f "$mysql_perms" "$mysql_dump" "$mysql_pid"

echo "## MySQL configuration complete"


#======================================
# SSL Certificates Configuration
#--------------------------------------
echo '** Rehashing SSL Certificates...'
c_rehash

# Allow large files
sed -i -e 's@.*upload_max_filesize.*=.*@upload_max_filesize = 513M@' /etc/php5/cli/php.ini
sed -i -e 's@.*post_max_size.*=.*@post_max_size = 513M@'             /etc/php5/cli/php.ini
sed -i -e 's@.*upload_max_filesize.*=.*@upload_max_filesize = 513M@' /etc/php5/apache2/php.ini
sed -i -e 's@.*post_max_size.*=.*@post_max_size = 513M@'             /etc/php5/apache2/php.ini
sed -i -e 's@.*always_populate_raw_post_data.*=.*@always_populate_raw_post_data = -1@' /etc/php5/cli/php.ini
sed -i -e 's@.*always_populate_raw_post_data.*=.*@always_populate_raw_post_data = -1@' /etc/php5/apache2/php.ini

# convert shell variable HOME to environment variable HOME for sake of smbclient.
sed -i -e 's@^HOME=@export HOME=@' /usr/sbin/start_apache2

## The tar ball already packages everything as wwwrun:www. 
## (Not sure why we end up with root:root)
## autoconf.php is owned by root and not writable.
chown -R wwwrun:www $destdir/data
chmod 770           $destdir/data
#
chown -R wwwrun:www $destdir/config
chmod 775           $destdir/config
chmod g+w           $destdir/config/*

if [ -x /obfuscated_apps/install_apps.sh ] ; then
  /obfuscated_apps/install_apps.sh $destdir
fi

# remove apps that Matt does not want in the appliance:
for banned in user_webdavauth user_external user_shibboleth; do
  rm -rf $destdir/apps/$banned
done

/sbin/chkconfig apache2 on


## make /etc/issue nice.
cat >> /etc/init.d/boot.local << EOF2
# /etc/issue can interpolate the ip address with \4, but needs the correct default device for this.
# default via 192.168.176.1 dev wlp3s0  proto static
default_dev=\$(ip r | grep default | sed -e 's@.*dev\\s*@@' -e 's@\\s.*@@')
ip_address=\$(ip addr show dev \$default_dev | grep inet | sed -e 's@.*inet\\s*@@' -e 's@/.*@@')
test -f /etc/issue      && sed -i -e "s@4{\\w*}@4{\$default_dev}@" /etc/issue
test -f /etc/issue.orig && sed -i -e "s@4{\\w*}@4{\$default_dev}@" /etc/issue.orig

/root/bin/update_trusted_domains $ip_address
/root/bin/update_config_php $destdir/config/config.php 'overwritewebroot' '/owncloud'
EOF2

# make the version number appear in the hostname
echo "$displayname-$version" | tr . - > /etc/HOSTNAME

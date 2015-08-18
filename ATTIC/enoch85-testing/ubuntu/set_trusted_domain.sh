#!/bin/bash

IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')

cat <<TRUSTED >> /var/www/owncloud/config/config.php
'trusted_domains' =>
  array (
    0 => '$ADDRESS',
  ),
'overwrite.cli.url' => 'http://$ADDRESS/owncloud',
);
TRUSTED

exit 0

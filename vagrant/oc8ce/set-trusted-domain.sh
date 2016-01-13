#!/bin/bash
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')

# only set trusted domian once
# then delete this file in check.init.sh after the script is run to avoid new config every time the VM boots
php /var/scripts/update-config.php $oc/config/config.php 'trusted_domains[]' localhost ${ADDRESS[@]} $(hostname) $(hostname --fqdn)
php /var/scripts/update-config.php $oc/config/config.php overwrite.cli.url https://$ADDRESS/owncloud

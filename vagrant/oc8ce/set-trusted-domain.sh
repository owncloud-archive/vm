#!/bin/bash

# only set trusted domian once
# then delete this file from in check.init.sh after the script is run to avoid new config every time the VM boots
php /var/scripts/update-config.php $oc/config/config.php 'trusted_domains[]' localhost ${ADDRESSES[@]} $(hostname) $(hostname --fqdn)
php /var/scripts/update-config.php $oc/config/config.php overwrite.cli.url https://$ADDRESS/owncloud

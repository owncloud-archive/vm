#! /bin/bash
# install-additional-apps.sh
#
# This script is intended to be run twice:
# First: without parameter at build time.		(from build-ubuntu-vm.sh)
# Second: with parameter 'enable' at first-boot. 	(from check-init.sh)

oc=/var/www/owncloud

test -z "$DEBUG" && DEBUG=true
set -x

if [ x$1 == xenable ]; then
  # Enable the apps we want the user to have
  # Check the dirs, in case they were not installed.

  if [ -d $oc/apps/galleryplus ]; then
    # Disable gallery, and enable GalleryPlus
    sudo -u www-data php $oc/occ app:disable gallery
    sudo -u www-data php $oc/occ app:enable galleryplus
  fi

  if [ -d $oc/apps/mail ]; then
    # Enable Mail
    sudo -u www-data php $oc/occ app:enable mail
    php /var/scripts/update-config.php $oc/config/config.php 'app.mail.server-side-cache.enabled' 'true'
  fi

  if [ -d $oc/apps/documents ]; then
    # Enable Documents
    sudo -u www-data php $oc/occ app:enable documents
    php /var/scripts/update-config.php $oc/config/config.php 'preview_libreoffice_path' '/usr/bin/libreoffice'
  fi
  exit 0
fi	# end of enable code.


test 0$INSTALL_ADDITIONAL_APPS -eq 1 || exit 0

# We need unzip to perform this	
apt-get install unzip -y

# FIXME: We also need hg from mercurial for *something*. It costs 95 MB!
# FIXME: Please document this.
# apt-get install mercurial -y

# FIXME: should we chown/chgroup here, to be safe that www-data:www-data is used?
# Download and install GalleryPlus
wget -q https://github.com/interfasys/galleryplus/archive/master.zip
unzip -q master.zip
rm master.zip
mv galleryplus-master/ galleryplus/
mv galleryplus/ $oc/apps

# Download and install Documents
wget -q https://github.com/owncloud/documents/archive/master.zip
unzip -q master.zip
rm master.zip
mv documents-master/ documents/
mv documents/ $oc/apps
## Make it possible to enable MS-document support
$DEBUG || apt-get install --no-install-recommends libreoffice -q -y
## Add Libreoffice PPA 
$DEBUG || sudo apt-add-repository ppa:libreoffice/libreoffice-5-0 -y

# Download and install Mail
wget -q https://github.com/owncloud/mail/archive/master.zip
unzip -q master.zip
rm master.zip
mv mail-master/ mail/
mv mail/ $oc/apps
# According to README.md https://github.com/owncloud/mail#developer-setup-info
cd $oc/apps/mail

# FIXME: Please document this. Looks like a rootkit to me.
curl -sS https://getcomposer.org/installer | php
php composer.phar install
rm composer.phar



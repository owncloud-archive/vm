#! /bin/bash
# install-additional-apps.sh

test -z "$DEBUG" && DEBUG=true
set -x

# We need unzip to perform this	
apt-get install unzip -y

# FIXME: We also need hg from mercurial for *something*. It costs 95 MB!
# FIXME: Please document this.
# apt-get install mercurial -y

# Download and install GalleryPlus
wget -q https://github.com/interfasys/galleryplus/archive/master.zip
unzip -q master.zip
rm master.zip
mv galleryplus-master/ galleryplus/
mv galleryplus/ /var/www/owncloud/apps

# Download and install Documents
wget -q https://github.com/owncloud/documents/archive/master.zip
unzip -q master.zip
rm master.zip
mv documents-master/ documents/
mv documents/ /var/www/owncloud/apps
## Make it possible to enable MS-document support
$DEBUG || apt-get install --no-install-recommends libreoffice -q -y
## Add Libreoffice PPA 
$DEBUG || sudo apt-add-repository ppa:libreoffice/libreoffice-5-0 -y

# Download and install Mail
wget -q https://github.com/owncloud/mail/archive/master.zip
unzip -q master.zip
rm master.zip
mv mail-master/ mail/
mv mail/ /var/www/owncloud/apps
# According to README.md https://github.com/owncloud/mail#developer-setup-info
cd /var/www/owncloud/apps/mail

# FIXME: Please document this. Looks like a rootkit to me.
curl -sS https://getcomposer.org/installer | php
php composer.phar install
rm composer.phar



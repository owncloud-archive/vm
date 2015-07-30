#! /bin/sh
#
# Requires: vagrant virtualbox-qt virtualbox-dkms zip


cat > Vagrantfile << EOF
\$script = <<SCRIPT
set -x
echo "admin\nadmin" | sudo passwd
wget $releaseKey
sudo apt-key add - < Release.key 
rm Release.key
sudo sh -c "echo 'deb $ocPackage /' >> /etc/apt/sources.list.d/owncloud.list"
sudo apt-get update -y
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
sudo apt-get install -y owncloud
cd /var/www/owncloud/apps
# temporary bugfix already fixed in :testing
sudo chown -c www-data .
# “zero out” the drive...
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "$vmBoxName"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "$vmBoxUrl"

  config.vm.network :forwarded_port, guest: 80, host: 8888
  config.vm.provider :virtualbox do |vb|
      vb.name = "$imageVersion+$ocVersion"
  end
	config.vm.provision "shell",
	inline: \$script
end
EOF
set -x
vagrant up
vagrant halt
imagePath=$(VBoxManage list hdds | grep /$imageVersion+$ocVersion/)
#-->Location:       /home/stefan/VirtualBox VMs/xUbuntu14.04/box-disk1.vmdk
imagePath=${imagePath#*/}
imageName=${imagePath##*/}
imagePath=/$imagePath
#/home/stefan/VirtualBox VMs/xUbuntu14.04/box-disk1.vmdk
cp "$imagePath" .
zip $imageVersion+$ocVersion.vmdk.zip $imageName
rm $imageName

if [ "$imagePath" != "" ]
then vagrant destroy -f
fi
#only destroy if it could get hold of it with VBoxManage

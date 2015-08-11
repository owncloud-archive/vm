#! /bin/sh

ocObsRepo=http://download.opensuse.org/repositories/isv:ownCloud:community:testing/xUbuntu_14.04
ocPackage=$(echo $ocObsRepo | sed -e 's@:\([^/]\)@:/\1@')
releaseKey=$ocObsRepo/Release.key
ocVersion=$(curl -s -L http://download.opensuse.org/repositories/isv:ownCloud:community:testing/xUbuntu_14.04/Packages | grep -a1 'Package: owncloud$' | grep Version: | head -n 1 | sed -e 's/Version: /owncloud-/')
# ocVersion=ownCloud-8.1.0-6
buildPlatform=xUbuntu14.04
vmBoxName=ubuntu/trusty64
vmBoxUrl=https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box

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
      vb.name = "$buildPlatform+$ocVersion"
  end
	config.vm.provision "shell", path: "welcome.sh"
  #	inline: \$script
end
EOF
vagrant up
vagrant halt
VBoxImagePath=$(VBoxManage list hdds | grep /$buildPlatform+$ocVersion/)
#-->Location:       /home/$USER/VirtualBox VMs/xUbuntu14.04/box-disk1.vmdk
VBoxImagePath=${VBoxImagePath#*/}
VBoxImageName=${VBoxImagePath##*/}
VBoxImagePath=/$VBoxImagePath
imageName=$buildPlatform+$ocVersion
cp "$VBoxImagePath" $imageName.vmdk
zip $imageName.vmdk.zip $imageName.vmdk
rm $imageName.vmdk

if [ "$VBoxImagePath" != "" ]
then vagrant destroy -f
fi

#! /bin/sh
#
# Requires: vagrant virtualbox-qt virtualbox-dkms zip

cat > Vagrantfile << EOF
\$script = <<SCRIPT
set -x
echo "admin\nadmin" | passwd 
zypper --non-interactive --gpg-auto-import-keys addrepo $repoUrl
zypper --non-interactive --gpg-auto-import-keys addrepo $develRepoUrl
zypper --non-interactive --gpg-auto-import-keys refresh
zypper --non-interactive --gpg-auto-import-keys install ca-certificates
zypper --non-interactive --gpg-auto-import-keys install glibc-locale
zypper --non-interactive --gpg-auto-import-keys install owncloud
zypper --non-interactive install php5-libsmbclient
zypper --non-interactive install clamav
zypper --non-interactive install php5-APCu
zypper --non-interactive install php-mysql
zypper --non-interactive install landscape-sysinfo-mini
zypper --non-interactive install mariadb
zypper --non-interactive install telnet
zypper --non-interactive install traceroute
zypper --non-interactive install lsof
zypper --non-interactive install strace
zypper --non-interactive install kbd-wrapper	
zypper --non-interactive install vim
zypper --non-interactive install less
rpm -q --changelog owncloud | head -20
zypper --non-interactive --gpg-auto-import-keys addrepo $communityRepoUrl "community:/8.0/$buildPlatform/"
zypper --non-interactive --gpg-auto-import-keys addrepo $serverRepoUrl "server:php:extensions/$buildPlatform/"
zypper --non-interactive --gpg-auto-import-keys addrepo $distributionRepoUrl "distribution/$platformVersion/repo/oss/"
zypper --non-interactive --gpg-auto-import-keys addrepo $updateRepoUrl "update/$platformVersion/"
zypper --non-interactive --gpg-auto-import-keys removerepo "ownCloud Enterprise Edition Version 8.x ($buildPlatform)"
#zypper --non-interactive --gpg-auto-import-keys refresh 
rm /etc/motd 
touch /etc/motd
cp /vagrant/Tree.SUSE/* / -r
displayname=$displayname
version=$version
. /vagrant/config.sh

# “zero out” the drive...
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.provider "virtualbox" do |v|
  v.gui = true #================DEBUG ONLY====================
  v.memory = 1024
  end
  
 # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "$vmBoxName"
	
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "$vmBoxUrl"

  #config.ssh.username = "root" kills everything!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  config.vm.boot_timeout = 1800

  #config.vm.network :forwarded_port, guest: 80, host: 8888
  #asks for adapter which needs to be bridged
  #config.vm.network "public_network", :adapter=>1
  #config.vm.network "public_network", :bridge => 'wlan0' :adapter=>1 overrides NAT adapter may produce "vagrant ssh" problems
  #config.vm.network "public_network", :bridge => 'wlan0' #solve with VBoxManage modifyvm $buildPlatform+$ocVersion --nic1 bridged
  config.vm.provider :virtualbox do |vb|
      vb.name = "$buildPlatform+$ocVersion"
  end
	config.vm.provision "shell",
	inline: \$script
end
EOF
set -x
vagrant up
echo "Vagrant up done!"
echo "Closing..."
#==============================for openSUSE13.2:
if [ "$buildPlatform" != "openSUSE_13.1" ]
then vagrant halt 
#===========
#==============================for openSUSE13.1:
else
vagrant ssh -c "echo "admin\n" | sudo /sbin/shutdown -h now"
echo "admin\n" | /sbin/shutdown -h now #or vagrant halt(not working)
echo "Waiting for shutdown"
sleep 2
#===========
fi


#No Vagrant ssh after this line ======================================================== No Nat Adapter for Vagrant 
#Vboxmanage stuff =========================================================== 
echo "VBoxManage configuration"

VBoxManage modifyvm $buildPlatform+$ocVersion --nic1 bridged
VBoxManage modifyvm $buildPlatform+$ocVersion --bridgeadapter1 wlan0
VBoxManage modifyvm $buildPlatform+$ocVersion --macaddress1 auto

VBoxManage sharedfolder remove $buildPlatform+$ocVersion --name /vagrant
VBoxManage export $buildPlatform+$ocVersion -o $buildPlatform+$ocVersion.ovf  

#==============================Not destroying right now because of debug reasons

VBoxImagePath=$(VBoxManage list hdds | grep /$buildPlatform+$ocVersion/)
#Example:Location:       /home/stefan/VirtualBox VMs/xUbuntu14.04/box-disk1.vmdk
VBoxImagePath=${VBoxImagePath#*/}
VBoxImageName=${VBoxImagePath##*/}
VBoxImagePath=/$VBoxImagePath
#/home/stefan/VirtualBox VMs/xUbuntu14.04/box-disk1.vmdk
imageName=$buildPlatform+$ocVersion
cp "$VBoxImagePath" $imageName.vmdk
zip $imageName.vmdk.zip $imageName.vmdk
rm $imageName.vmdk

if [ "$VBoxImagePath" != "" ]
then vagrant destroy -f
fi
#only destroy if it could get hold of it with VBoxManage

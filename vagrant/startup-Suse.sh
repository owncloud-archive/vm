#! /bin/sh

. ./credentials.sh

ocVersion=Owncloud8.0.0-6
platformVersion=13.2
buildPlatform=openSUSE_$platformVersion

ocObsRepo=http://download.opensuse.org/repositories/isv:/ownCloud:/community/$buildPlatform/
ocPackage=$(echo $ocObsRepo | sed -e 's@:\([^/]\)@:/\1@')
repoUrl=http://download.opensuse.org/repositories/isv:/ownCloud:/community/$buildPlatform/isv:ownCloud:community.repo
develRepoUrl=http://download.opensuse.org/repositories/isv:ownCloud:devel/$buildPlatform/isv:ownCloud:devel.repo 
communityRepoUrl=http://download.opensuse.org/repositories/isv:/ownCloud:/community:/8.0/$buildPlatform/
serverRepoUrl=http://download.opensuse.org/repositories/server:php:extensions/$buildPlatform/
distributionRepoUrl=http://download.opensuse.org/distribution/$platformVersion/repo/oss/
updateRepoUrl=http://download.opensuse.org/update/$platformVersion/
vmBoxName=webhippie/opensuse13.2 #====Change needed
vmBoxUrl=https://atlas.hashicorp.com/webhippie/boxes/opensuse-$platformVersion/versions/1.0.0/providers/virtualbox.box
displayname=community-appliance
version=0.0.0


. ./applianceEngine-Suse.sh

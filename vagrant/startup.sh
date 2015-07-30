#! /bin/sh

ocObsRepo=http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/
ocPackage=$(echo $ocObsRepo | sed -e 's@:\([^/]\)@:/\1@')
releaseKey=$ocObsRepo\Release.key
ocVersion=ownCloud8.1.0-6
imageVersion=xUbuntu14.04
vmBoxName=ubuntu/trusty64
vmBoxUrl=https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box

. ./applianceEngine.sh

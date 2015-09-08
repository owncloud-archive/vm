#! /bin/sh
#
# release-dl-oo -- push released files into download.owncloud.org
# (c) Copyright 2015 jw@owncloud.com
#

## testing releases go here:
destdir=testing/vm
## production releases go here:
##destdir=production/vm

uploadurl=upload@dl-oo.owncloud.org:w/$destdir
downloadurl=download.owncloud.org/community/$destdir

echo uploading to $dest ...
set -x
sleep 3
sleep 2
sleep 1

imgdir=$(dirname $0)/img
for file in $imgdir/*.zip; do
  chmod 0644 $file
  rsync --progress --append-verify $file $uploadurl/
done

echo Download URL: $downloadurl


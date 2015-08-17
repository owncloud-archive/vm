#!/bin/sh
#
# mkvmdk-kiwi.sh creates the vmdk variant from the main kiwi file.

set -x
chmod u+w *vmdk.kiwi
cp eval-appliance-oc8ee.kiwi eval-appliance-oc8ee-vmdk.kiwi
patch -p0 < vmdk-kiwi.patch
chmod a-w *vmdk.kiwi

d=/tmp/_changes_$$/
mkdir -p $d/root
cp *.changes $d/root
(cd $d; tar zcvf - root) > changelog.tar.gz
rm -rf $d

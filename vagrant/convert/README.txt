# snippets to convert into different appliance formats, starting with vmdk
# ------------------------------------------------------------------------

# Requires: zip
# Requires: qemu-img fom qemu-tools
# Requires: ovftool 
#  Installation procedure: (ovftool, 40MB from VMware)
#  https://developercenter.vmware.com/tool/ovf/3.5.0
#  yes | sudo sh VMware-ovftool-3.5.0-1274719-lin.x86_64.bundle | cat
#   -> unpacks to /usr/lib/vmware-installer/ /usr/lib/vmware-ovftool/ /etc/vmware* /usr/bin/ovftool
# Requires: VBoxManage
#  Installation procedure (avoid dependencies: virtualbox-guest-kmp-default virtualbox-host-kmp-default)
#  zypper -d virtualbox
#  # None of the dependecies is needed for ldd VBoxManage.
#  rpm -Uhv /var/cache/zypp/packages/repo-update/x86_64/virtualbox-4.2.6-3.6.11.x86_64.rpm --nodeps
##
# 2014-10-21, jw using ovftool --lax option to help with vsphere hardware checks.
# 2014-12-05, jw added qi-vhd and vbm-vhd flavours: via qemu-img convert, and VBoxManage clonehd
# 2014-12-16, jw aded VBoxManage options: --variant Standard --type normal

dir=.

  mkdir $dir/ova
  # https://github.com/owncloud/enterprise/issues/367
  # try ID=101 otherLinux64Guest instead of ID=83, 
  sed -i -e's@suse-64@otherlinux-64@' $dir/vmx/*.vmx
  nice ovftool --lax $dir/vmx/*.vmx $dir/ova/$archive_name.ova
  # grep osType out.ovf
  #  <OperatingSystemSection ovf:id="101" vmw:osType="otherLinux64Guest">

  if [ -x /usr/bin/VBoxManage ]; then
    nice VBoxManage clonehd $dir/vmx/*.vmdk $dir/$archive_name-vbm.vhd --format VHD --variant Standard
    nice zip --junk-paths $dir/$archive_name-vbm.vhd.zip $dir/$archive_name-vbm.vhd
    rm $dir/$archive_name-vbm.vhd
  fi

  ## If this generates bad vhd disks, we can also create 
  ## them from *.vmdk instead of from *.qcow2
  qemu-img convert -f qcow2 -O vpc $qcow2 $dir/$archive_name-qic.vpc.vhd
  # prepare a nice *.XML to go into the zip with the vhd file?
  nice zip --junk-paths $dir/$archive_name-qic.vpc.vhd.zip $dir/$archive_name-qic.vpc.vhd
  rm $dir/$archive_name-qic.vpc.vhd

create a vhd image
------------------
# FROM http://superuser.com/questions/410940/how-to-create-vhd-disk-image-from-a-linux-live-system
# start with a raw mountable disk image
parted image.dd
 -> note the 'Start' offset of the parition you want.
# squeeze out unused space
mount -o loop,rw,offset=PARTITION_START -t ... /image.dd /mnt
cat /dev/zero > /mnt/zero.file; rm /mnt/zero.file
umount /mnt
# maybe use fdisk to alter the partition table of image.dd, so that there is no 83 in there?
VBoxManage convertfromraw image.dd image.vhd --format VHD
# VBoxManage clonehd <source.vmdk> <destination.vhd> --format VHD --variant Standard --type normal

# should be able to mount the vhd image using vdfuse or qemu-nbd
# See also: http://askubuntu.com/questions/19430/mount-a-virtualbox-drive-image-vdi


Kiwi examples OVF, VHD, VMX
===========================
https://github.com/openSUSE/kiwi/tree/master/doc/examples/suse-13.1
https://groups.google.com/forum/#!msg/kiwi-images/OY8nTNJT-Fo/ryPBo5CuTsMJ
kiwi --convert image-file.raw --format vhd
kiwi --convert image-file.raw --format ova

# qemu-img convert -f raw /usr/src/packages/KIWI-vmx/vmx/eval-appliance-oc7ee.x86_64-0.0.1.raw -O vmdk /usr/src/packages/KIWI-vmx/vmx/eval-appliance-oc7ee.x86_64-0.0.1.vmdk
# ls -l /var/tmp/build-root/images-x86_64/usr/src/packages/KIWI-vmx
qemu-img convert -f vmdk /usr/src/packages/KIWI-vmx/vmx/*.vmdk -O qcow2 /space/libvirt-images/oc/eval-appliance-oc7ee.qcow2


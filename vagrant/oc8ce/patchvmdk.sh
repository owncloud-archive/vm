#! /bin/sh
#
# workaround for qemu-img convert to not handle VMDK-Format 03
#
#   qemu-img: 'image' uses a vmdk feature which is not supported by this qemu version: VMDK version 3
#
# They claim to only support VMDK-Format 02, but patching the version is sufficient.
# They don't know that they actually handle 03 too.
#
# Inspired by https://github.com/erik-smit/one-liners/blob/master/qemu-img.vmdk3.hack.sh
#
# (c) 2015 jw@owncloud.com

file=$1
vers=$2

footer_off=$[$(wc -c < $file) - 0x400]
magic=$(xxd -l 4 -s $footer_off -ps $file)

## sanity
if [ "$magic" != "4b444d56" ]; then	# letters KDMV
  echo "VMDK magic 4b444d56  not seen at offset $footer_off: found $magic instead."
  exit 0
fi

## show wht we have.
echo "VMDK version: $(xxd -l 1 -s $[$footer_off + 4] -ps $file)"

test -z "$vers" && exit 0

## patch new number.
printf "%08x:%s\n" $[$footer_off + 4] $vers | xxd -r - $file

## show success.
echo "VMDK version: $(xxd -l 1 -s $[$footer_off + 4] -ps $file)"


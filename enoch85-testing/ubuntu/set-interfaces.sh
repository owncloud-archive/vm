#!/bin/sh
IFACE="eth0"

IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
INTERFACES="/etc/network/interfaces"

ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
NETMASK=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $8; exit}')
GATEWAY=$($IP route | awk '/\<default\>/ {print $3; exit}')

cat <<-IPCONFIG > "$INTERFACES"
        auto lo $IFACE

        iface lo inet loopback

        iface $IFACE inet static

                address $ADDRESS
                netmask $NETMASK
                gateway $GATEWAY

# Exit and save:	[CTRL+X] + [Y] + [ENTER]
# Exit without saving:	[CTRL+X]

IPCONFIG

exit 0

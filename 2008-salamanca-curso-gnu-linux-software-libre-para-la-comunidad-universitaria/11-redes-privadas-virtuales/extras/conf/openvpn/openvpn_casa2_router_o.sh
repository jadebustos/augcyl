#!/bin/sh
install -d /dev/net
mknod /dev/net/tun c 10 200 2>/dev/null
openvpn --remote 88.4.5.6 --rport 8080 --nobind --dev tun1 --ifconfig 192.168.255.1 192.168.255.2 --secret static.key 0 --daemon
route add -host 10.0.1.92 gw 192.168.255.2
route add -net 10.0.2.0 netmask 255.255.255.0 gw 192.168.255.2


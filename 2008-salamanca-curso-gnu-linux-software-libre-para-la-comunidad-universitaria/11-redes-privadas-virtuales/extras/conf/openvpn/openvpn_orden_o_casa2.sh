#!/bin/sh
# create /dev/net/tun device (most distributions include it)
install -d /dev/net
mknod /dev/net/tun c 10 200 2>/dev/null
# start openvpn in port 8080
openvpn --lport 8080 --dev tun1 --ifconfig 192.168.255.2 10.0.1.93 --secret static.key 1 --daemon
route add -net 192.168.1.0 netmask 255.255.255.0 gw 10.0.1.93
route add -net 192.168.2.0 netmask 255.255.255.0 gw 10.0.1.93

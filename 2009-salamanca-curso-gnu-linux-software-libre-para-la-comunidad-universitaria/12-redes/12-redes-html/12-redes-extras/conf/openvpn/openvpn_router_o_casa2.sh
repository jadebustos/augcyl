#!/bin/sh
# create /dev/net/tun device (most distributions include it)
install -d /dev/net
mknod /dev/net/tun c 10 200 2>/dev/null
# start openvpn in port 8080; connect with 88.1.2.3:8081
openvpn --lport 8080 --dev tun1 --ifconfig 192.168.255.2 192.168.255.1 --float --secret static.key 1 --daemon
# route traffic to 192.168.1.0/24 to tunnel device
route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.255.1

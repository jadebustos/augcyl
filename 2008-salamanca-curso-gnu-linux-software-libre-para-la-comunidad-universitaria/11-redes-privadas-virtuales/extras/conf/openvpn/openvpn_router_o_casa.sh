#!/bin/sh
# create /dev/net/tun device (most distributions include it)
install -d /dev/net
mknod /dev/net/tun c 10 200 2>/dev/null
# start openvpn in port 8080; connect with 88.1.2.3:8081
openvpn --remote 88.1.2.3 --rport 8081 --lport 8080 --dev tun1 --ifconfig 192.168.255.2 192.168.255.1 --float --secret static.key 1 --daemon
# route traffic to 192.168.1.0/24 to tunnel device
route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.255.1
# filter traffic to 192.168.1.0/24 from any host except 10.0.1.92
#iptables -A OUTPUT --source ! 10.0.1.92 -o tun1 -j REJECT
#iptables -A FORWARD --source ! 10.0.1.92 -o tun1 -j REJECT

#!/bin/sh
# create /dev/net/tun device (most distributions include it)
install -d /dev/net
mknod /dev/net/tun c 10 200 2>/dev/null
# start openvpn in port 8081; connect with 88.4.5.6:8080
openvpn --remote 88.4.5.6 --rport 8080 --lport 8081 --dev tun1 --ifconfig 192.168.255.1 192.168.255.2 --secret static.key 0 --daemon
route add -host 10.0.1.92 gw 192.168.255.2
route add -net 10.0.2.0 netmask 255.255.255.0 gw 192.168.255.2
# reject traffic from any host except 10.0.1.92
#iptables -A INPUT --source ! 10.0.1.92 -i tun1 -j REJECT
#iptables -A FORWARD --source ! 10.0.1.92 -i tun1 -j REJECT


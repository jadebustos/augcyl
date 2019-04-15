#!/bin/sh
iptables -t nat -I POSTROUTING --source 192.168.1.0/24 --destination 10.0.1.92 -j ACCEPT

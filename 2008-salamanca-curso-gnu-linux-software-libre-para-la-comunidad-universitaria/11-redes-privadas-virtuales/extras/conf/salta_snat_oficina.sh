#!/bin/sh
iptables -t nat -I POSTROUTING --destination 192.168.1.0/24 --source 10.0.1.92 -j ACCEPT

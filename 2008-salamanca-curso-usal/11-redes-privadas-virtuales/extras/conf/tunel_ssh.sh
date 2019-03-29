#!/bin/sh
pppd updetach nobsdcomp nodeflate usepeerdns noauth connect-delay 10000 pty "ssh -p 10000 root@88.4.5.6 -o ServerAliveInterval=120 -t -t pppd noauth 192.168.255.2:10.0.1.93"

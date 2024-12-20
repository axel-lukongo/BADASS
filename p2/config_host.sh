#!/bin/bash
host_id=$(hostname | cut -d '-' -f 2)

if [ "$host_id" -eq 1 ]; then
	ip addr add 192.168.1.3/24 dev eth0
	ip link set eth0 up
	ip route add default via 192.168.1.1
else
	ip addr add 192.168.1.4/24 dev eth0
	ip link set eth0 up
	ip route add default via 192.168.1.2
fi
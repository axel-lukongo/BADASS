#!/bin/bash
host_id=$(hostname)

if [ "$host_id" == "host_alukongo-1" ]; then
	ip addr add 30.1.1.1/24 dev eth0
	ip link set eth0 up
#	ip route add default via 192.168.1.1
else
	ip addr add 30.1.1.2/24 dev eth0
	ip link set eth0 up
#	ip route add default via 192.168.1.2
fi

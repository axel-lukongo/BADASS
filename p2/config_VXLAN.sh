#!/bin/bash
router_id=$(hostname | cut -d '-' -f 2)
if [[ $1 == 'multi' ]]; then
	ip link add name vxlan10 type vxlan id 10 dev eth0 \
		group 239.1.1.1 dstport 4789
else
	ip link add name vxlan10 type vxlan id 10 dev eth0 \
		local 10.1.1.$router_id remote 10.1.1.$((3-$router_id)) dstport 4789
fi
brctl addbr br0
brctl addif br0 eth1
brctl addif br0 vxlan10

if [ "$router_id" -eq 1 ]; then
	ip addr add 10.1.1.1/24 dev eth0 # it just to config 
	ip addr add 192.168.1.1/24 dev br0
else
	ip addr add 10.1.1.2/24 dev eth0 # it just to config 
	ip addr add 192.168.1.2/24 dev br0
fi
ip link set dev br0 up
ip link set dev vxlan10 up

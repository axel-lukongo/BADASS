#!/bin/bash
ip link add name vxlan10 type vxlan id 10 dstport 4789
ip link set dev br0 up
ip link set dev vxlan10 up

brctl addbr br0
brctl addif br0 eth1
brctl addif br0 vxlan10




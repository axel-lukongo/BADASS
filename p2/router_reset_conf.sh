#!/bin/bash

echo "Réinitialisation des configurations sur $(hostname)..."

# Supprimer les interfaces VXLAN et les ponts
ip link set vxlan10 down 2>/dev/null
ip link delete vxlan10 2>/dev/null
ip link set br0 down 2>/dev/null
brctl delbr br0 2>/dev/null

# Réinitialiser les démons FRR (zebra, bgpd, ospfd)
vtysh << EOF
configure terminal
 no router bgp
 no router ospf
exit
EOF

echo "Réinitialisation terminée pour $(hostname)."


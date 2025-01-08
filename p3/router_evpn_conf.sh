#!/bin/bash
router_id=$(hostname | cut -d '-' -f 2)
case $router_id in
	1)
		vtysh <<- EOF
			configure terminal
				router bgp 1
					neighbor ibgp peer-group
					neighbor ibgp remote-as 1
					neighbor ibgp update-source lo
					bgp listen range 1.1.1.0/24 peer-group ibgp
					address-family l2vpn evpn
						neighbor ibgp activate
						neighbor ibgp route-reflector-client
					exit-address-family
				router ospf
					network 0.0.0.0/0 area 0
			end
		EOF
		;;
	2 | 3 | 4)
		vtysh <<- EOF
			configure terminal
				interface eth0
					ip ospf area 0
				interface lo
					ip ospf area 0
				router bgp 1
					neighbor 1.1.1.1 remote-as 1
					neighbor 1.1.1.1 update-source lo
					address-family l2vpn evpn
						neighbor 1.1.1.1 activate
						advertise-all-vni
					exit-address-family
				router ospf
			end
		EOF
		;;
esac
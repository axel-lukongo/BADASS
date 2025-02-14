# R3 ip conf
vtysh
enable
conf t

hostname router_alukongo-3
no ipv6 forwarding
!
interface eth1
 ip address 10.1.1.6/30
 ip ospf area 0
!
interface lo
 ip address 1.1.1.3/32
 ip ospf area 0
!
router bgp 1
 neighbor 1.1.1.1 remote-as 1
 neighbor 1.1.1.1 update-source lo
 !
 address-family l2vpn evpn
  neighbor 1.1.1.1 activate
 exit-address-family
!
router ospf 

do write




# interface eth1
# no sh
# ip address 20.1.1.253/24
# ip ospf area 0

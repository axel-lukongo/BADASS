#R2
ip link add br0 type bridge
ip link set dev br0 up
ip link add name vxlan10 type vxlan id 10 dstport 4789
ip link set dev vxlan10 up
brctl addif br0 vxlan10
brctl addif br0 eth1
# ip link set eth1 up



vtysh 
enable 
conf t 

hostname router_alukongo-2 
no ipv6 forwarding 
!

interface eth0 
 ip address 10.1.1.2/30 
 ip ospf area 0
!
interface lo 
 ip address 1.1.1.2/32 
 ip ospf area 0
!
router bgp 1
 neighbor 1.1.1.1 remote-as 1 
 neighbor 1.1.1.1 update-source lo
 !
 address-family l2vpn evpn 
  neighbor 1.1.1.1 activate 
  advertise-all-vni 
 exit-address-family
!
router ospf 
!
# do write


# int eth1
# ip address 20.1.1.254/24 
# ip ospf area 0



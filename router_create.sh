### Router Script ###
#!/bin/bash
#

router=router
gw=192.168.0.1
ip netns add ${router}

#router|vlan_id|ip_addr
route_if="
router|10|192.168.0.4/24
router|100|10.20.0.1/24
router|104|172.16.0.1/24
router|106|172.16.1.1/24
"

for each in $route_if; do
	router=`echo $each | cut -d\| -f1`
	vlan_id=`echo $each | cut -d\| -f2`
	ip_addr=`echo $each | cut -d\| -f3`
	br_veth=br-v${vlan_id}
	rt_veth=rt-v${vlan_id}
	echo Creating int pair ${br_veth}:${rt_veth} on ${router} attached to vlan ${vlan_id}
	#Clean up to remove port
	ovs-vsctl del-port ${br_veth}
	ip link add ${br_veth} type veth peer name ${rt_veth}
	ip link set ${rt_veth} netns router
	ip netns exec ${router} ip addr add ${ip_addr} dev ${rt_veth}
	ip netns exec ${router} ip link set ${rt_veth} up	
	ovs-vsctl add-port br-trunk0 ${br_veth}
	ovs-vsctl set port ${br_veth} tag=${vlan_id}
	ip link set ${br_veth} up
	ip netns exec ${router} ip link set ${rt_veth} up
done

ip netns exec router route add -net 0.0.0.0 gw ${gw}


ip netns exec router iptables -t nat -A POSTROUTING -o rt-v10 -j MASQUERADE
ip netns exec router iptables -A FORWARD -i rt-v10 -o rt-v104 -m state --state RELATED,ESTABLISHED -j ACCEPT
ip netns exec router iptables -A FORWARD -i rt-v10 -o rt-v104 -j ACCEPT
ip netns exec router iptables -t nat -A POSTROUTING -o rt-v104 -d 172.16.0.0/24 -j SNAT --to-source 172.16.0.1
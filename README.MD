NUC Pre Buid Notes
##################

1. Install Ubuntu with KVM 


#Prepare for KVM Networking
2. install OVS 
apt-get -y install openvswitch-switch virtinst


3. Setup OVS
ovs-vsctl add-br br-trunk0
ovs-vsctl add-port br-trunk0 eth0 

4. Create local bridge
ovs-vsctl add-port br-trunk0 mgmnt0 -- set interface mgmnt0 type=internal
ovs-vsctl set port mgmnt0 tag=10

5. Setup Host networking
#Configure Networking
auto eth0
iface eth0 inet manual
  down ip link set $IFACE down
  up ip link set $IFACE up 


auto mgmnt0
iface mgmnt0 inet static
  address 192.168.0.202
  netmask 255.255.255.0
  gateway 192.168.0.1
  dns-nameservers 8.8.8.8

6. Config sudo file
===sudoers configuration===
sudo -i
sed -i 's/^\%sudo.*ALL/\%sudo   ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^\%admin.*ALL/\%admin  ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

7. Create ssh keys as root
ssh-keygen
cp /root/.ssh/id-rsa.pub /root/.ssh/authorized_keys
scp /root/.ssh/* {to other nodes ip}/root/.ssh


8. Createh Libvirt Network
This script will create the KVM networking config for you


9. Prepare Libvirt
9.1 Enable VNC
	vi  /etc/libvirt/qemu.conf
	
	#find and uncomment the following line
	vnc_listen = "0.0.0.0"

sed -i 's/^#vnc_listen = "0.0.0.0"/vnc_listen = "0.0.0.0"/' /etc/libvirt/qemu.conf


10. Create new fuel VM # 
# Create boot-net
ovs-vsctl add-br bootnet br-trunk0 10 
# Create virsh network
# boot-net.xml
<network connections='2'>
  <name>boot-net</name>
  <uuid>2ab60533-fe2d-489e-963d-cef9e41f407f</uuid>
  <forward mode='bridge'/>
  <bridge name='bootnet'/>
  <virtualport type='openvswitch'/>
</network>
# end

virsh net-create ./boot-net.xml


11. Create containers
# This script will create containers on the nodes based on 
# the nodes variable table, Please ensure that the networking
# and ssh is all working before running.












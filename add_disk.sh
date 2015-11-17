### Multi Node Creation Script ###
#!/bin/bash
# This assumes that you have completed the network setup
# The user profile needs to have a ssh key configured and 
# have rights to create instances on the nodes. 
#
#General Defaults 
diskpath="/var/lib/libvirt/images/"
vmdomain=cloudbuilderhq.co.za

#vmname|disksize|vcpus|ram|nodeip
nodes="
fuel-control-1|50|2|2097152|192.168.0.200|20
fuel-control-2|50|2|2097152|192.168.0.201|20
fuel-control-3|50|2|2097152|192.168.0.202|20
"

for each in $nodes; do
	vmname=`echo $each | cut -d\| -f1`
	disksize=`echo $each | cut -d\| -f2`
	vcpus=`echo $each | cut -d\| -f3`
	ram=`echo $each | cut -d\| -f4`
	nodeip=`echo $each | cut -d\| -f5`
	disk2size=`echo $each | cut -d\| -f6`

	ssh $nodeip "virsh detach-disk ${vmname} vdb --config --persistent"	
	ssh $nodeip "virsh destroy ${vmname}"
	ssh $nodeip "virsh start ${vmname}"
	ssh $nodeip "rm -f ${diskpath}${vmname}-disk2.qcow2"	
	ssh $nodeip "qemu-img create -f qcow2 ${diskpath}${vmname}-disk2.qcow2 ${disk2size}G"	
	ssh $nodeip "virsh attach-disk ${vmname} ${diskpath}${vmname}-disk2.qcow2 vdb --subdriver qcow2 --config --persistent"
	ssh $nodeip "virsh destroy ${vmname}"
	ssh $nodeip "virsh start ${vmname}"
	
done

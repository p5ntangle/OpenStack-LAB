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
. $1

for each in $nodes; do
	vmname=`echo $each | cut -d\| -f1`
	disksize=`echo $each | cut -d\| -f2`
	vcpus=`echo $each | cut -d\| -f3`
	ram=`echo $each | cut -d\| -f4`
	nodeip=`echo $each | cut -d\| -f5`

	ssh $nodeip "virsh destroy ${vmname}"
	ssh $nodeip "virsh undefine ${vmname}"
        ssh $nodeip "rm ${diskpath}${vmname}.qcow2"
done

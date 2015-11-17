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
fuel-control-1|50|2|2097152|192.168.0.200
fuel-control-2|50|2|2097152|192.168.0.201
fuel-control-3|50|2|2097152|192.168.0.202
fuel-compute-1|50|8|8388608|192.168.0.201
fuel-compute-2|50|8|8388608|192.168.0.201
fuel-compute-3|50|8|8388608|192.168.0.202
fuel-ceph-1|50|1|2097152|192.168.0.200
fuel-ceph-2|50|1|2097152|192.168.0.201
fuel-ceph-3|50|1|2097152|192.168.0.202
"

for each in $nodes; do
	vmname=`echo $each | cut -d\| -f1`
	disksize=`echo $each | cut -d\| -f2`
	vcpus=`echo $each | cut -d\| -f3`
	ram=`echo $each | cut -d\| -f4`
	nodeip=`echo $each | cut -d\| -f5`

	ssh $nodeip "virsh destroy ${vmname}"
	ssh $nodeip "virsh start ${vmname}"
done
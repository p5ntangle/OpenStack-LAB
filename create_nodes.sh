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

	ssh $nodeip "rm /tmp/${vmname}.xml"
	ssh $nodeip "cat <<END >/tmp/${vmname}.xml
		<domain type='kvm' id='15'>
		  <name>${vmname}</name>
		  <memory unit='KiB'>${ram}</memory>
		  <currentMemory unit='KiB'>${ram}</currentMemory>
		  <vcpu placement='static'>${vcpus}</vcpu>
		  <resource>
			<partition>/machine</partition>
		  </resource>
		  <os>
			<type arch='x86_64' machine='pc-i440fx-trusty'>hvm</type>
			<boot dev='network'/>
			<boot dev='hd'/>
		  </os>
		  <features>
			<acpi/>
			<apic/>
			<pae/>
		  </features>
		  <clock offset='utc'/>
		  <on_poweroff>destroy</on_poweroff>
		  <on_reboot>restart</on_reboot>
		  <on_crash>restart</on_crash>
		  <devices>
			<emulator>/usr/bin/kvm-spice</emulator>
			<disk type='file' device='disk'>
			  <driver name='qemu' type='qcow2'/>
			  <source file='${diskpath}${vmname}.qcow2'/>
			  <target dev='vda' bus='virtio'/>
			  <alias name='virtio-disk0'/>
			</disk>
		   <interface type='network'>
			  <source network='ovs-network' portgroup='pxe'/>
			  <model type='virtio'/>
		   </interface>
		   <interface type='network'>
			  <source network='ovs-network' portgroup='vlan-all'/>
			  <model type='virtio'/>
		   </interface>
			<serial type='pty'>
			  <source path='/dev/pts/1'/>
			  <target port='0'/>
			  <alias name='serial0'/>
			</serial>
			<console type='pty' tty='/dev/pts/1'>
			  <source path='/dev/pts/1'/>
			  <target type='serial' port='0'/>
			  <alias name='serial0'/>
			</console>
			<input type='mouse' bus='ps2'/>
			<input type='keyboard' bus='ps2'/>
			<graphics type='vnc' port='5900' autoport='yes' listen='0.0.0.0'>
			  <listen type='address' address='0.0.0.0'/>
			</graphics>
			<video>
			  <model type='cirrus' vram='9216' heads='1'/>
			  <alias name='video0'/>
			</video>
			<memballoon model='virtio'>
			  <alias name='balloon0'/>
			</memballoon>
		  </devices>
		</domain>
END
"
	
	ssh $nodeip "qemu-img create -f qcow2 ${diskpath}${vmname}.qcow2 ${disksize}G"	

	ssh $nodeip "virsh define /tmp/${vmname}.xml"
	ssh $nodeip "virsh autostart ${vmname}"
	ssh $nodeip "virsh start ${vmname}"

done

### Multi Node Creation Script ###
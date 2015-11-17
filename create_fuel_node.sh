### Fuel Node Creation Script ####
#!/bin/bash
# Create a new fuel noe and boot from a CD image
#
vmname=fuel
vmdomain=lab.mirantis.com
disksize=60
vcpus=2
ram=4194304
diskpath="/var/lib/libvirt/images/"
cdpath="/opt/iso/MirantisOpenStack-6.1.iso"

qemu-img create -f qcow2 ${diskpath}${vmname}.qcow2 ${disksize}G

cat <<END >/root/${vmname}.xml
<domain type='kvm'>
  <name>${vmname}</name>
  <memory unit='KiB'>${ram}</memory>
  <currentMemory unit='KiB'>${ram}</currentMemory>
  <vcpu placement='static'>${vcpus}</vcpu>
  <resource>
    <partition>/machine</partition>
  </resource>
  <os>
    <type arch='x86_64' machine='pc-i440fx-trusty'>hvm</type>
    <boot dev='hd'/>
    <boot dev='cdrom'/>
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
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='${cdpath}'/>
      <target dev='hdc' bus='ide'/>
      <readonly/>
      <address type='drive' controller='0' bus='1' unit='0'/>
    </disk>
    <interface type='network'>
       <source network='ovs-network' portgroup='pxe'/>
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
    <graphics type='vnc' port='-1' autoport='yes' listen='0.0.0.0'>
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

virsh define /root/${vmname}.xml
virsh start ${vmname}
####

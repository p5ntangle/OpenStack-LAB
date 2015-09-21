#### network.xml ####
#!/bin/bash
# This script will prepare the ovs-network for virsh
#
trunkif=br-trunk0
cat <<END >/tmp/ovs-network.xml
<network>
  <name>ovs-network</name>
  <forward mode='bridge'/>
  <bridge name='${trunkif}'/>
  <virtualport type='openvswitch'/>
  <portgroup name='pxe'>
    <vlan>
      <tag id='100'/>
    </vlan>
  </portgroup>
  <portgroup name='management'>
    <vlan>
      <tag id='101'/>
    </vlan>
  </portgroup>
  <portgroup name='private'>
    <vlan>
      <tag id='102'/>
    </vlan>
  </portgroup>  
  <portgroup name='storage'>
    <vlan>
      <tag id='103'/>
    </vlan>
  </portgroup>  
  <portgroup name='public'>
    <vlan>
      <tag id='104'/>
    </vlan>
  </portgroup>    
  <portgroup name='trunk'>
    <vlan trunk='yes'>
      <tag id='101'/>
      <tag id='102'/>
      <tag id='103'/>
      <tag id='104'/>
    </vlan>
  </portgroup>
</network>
END
virsh net-define /tmp/ovs-network.xml
virsh net-start /tmp/ovs-network.xml
#### network.xml ####

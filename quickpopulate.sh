#!/bin/bash
# Quick Populate Cloud
# Useful to quickly populate a openstack cloud with data
# Must source openrc before running
# Tenant and Users

tenant_data="
Acme|Acme Demo Tenant|AcmeUser1|AcmeUser2|10.40.10.0/24
NewCo|NewCo Demo Tenant|NewCoUser1|NewCoUser2|10.40.20.0/24
VolMedia|VolMedia Demo Tenant|VolMediaUser1|VolMediaUser2|10.40.30.0/24
SpanIT|SpanIT Demo Tenant|SpanITUser1|SpanITUser2|10.40.40.0/24
"
IFS=$'\n'
for entry in ${tenant_data} ; do 
  name=`echo ${entry} | cut -d\| -f1 `
  desc=`echo ${entry} | cut -d\| -f2 `
  u1=`echo ${entry} | cut -d\| -f3 `
  u2=`echo ${entry} | cut -d\| -f4 `
  keystone tenant-create --name ${name} --description ${desc}
  keystone user-create --name ${u1} --tenant ${name} --pass 123456 
  keystone user-role-add --user admin --role admin --tenant ${name}
done


IFS=$'\n'
for entry in ${tenant_data} ; do 
  name=`echo ${entry} | cut -d\| -f1 `
  ip=`echo ${entry} | cut -d\| -f5 `
  t_id=`keystone tenant-get ${name} |  grep id | cut -d\| -f3 |  sed -e 's/^ *//' -e 's/ *$//' `
  neutron net-create ${name}_net --tenant-id ${t_id}
  subnet_id=`neutron subnet-create ${name}_net ${ip} --tenant-id ${t_id} |  grep " id "| cut -d\| -f3 |  sed -e 's/^ *//' -e 's/ *$//' `
  router_id=`neutron router-create ${name}_router --tenant-id ${t_id} |  grep " id "| cut -d\| -f3 |  sed -e 's/^ *//' -e 's/ *$//' `
  neutron router-interface-add ${router_id} subnet=${subnet_id}
done


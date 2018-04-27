#!/bin/bash

if [ -z "$1" ]
  then 
    echo ' '
    echo 'Script requires a input file that contains a list of hosts'
    echo 'The file should contain a variable called nodes with a pipe|'
    echo 'delimited list on per line of name|ip|mac'
    echo ' '
    exit 0
fi

. $1

IFS=$'\n'

for each in $nodes; do
  node_name=`echo $each | cut -d\| -f 1`
  node_ip=`echo $each | cut -d\| -f 2`
  node_mac=`echo $each | cut -d\| -f 3`
  
  echo "Waking UP!: $node_name $node_ip"
  wakeonlan $node_mac > /dev/null 2>&1
  
done

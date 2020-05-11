#!/bin/bash

docker run --name watch -d --network=host -v /root/OpenStack-LAB/nodes/netboot:/netboot -t som/watch

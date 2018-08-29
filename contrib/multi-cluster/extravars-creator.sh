#!/bin/bash

# Usage: ./contrib/multi-cluster/extravars-creator.sh $number_of_clusters

# Alright what do we need...
# 1. We need to generate inventories..

echo "Warning: You're about to delete the existing extravars files!"
# sleep 2

rm -Rf ./inventory/multi-cluster
mkdir -p ./inventory/multi-cluster

masternumber=-2

for (( c=1; c<=$1; c++ ))
do
  filename="./inventory/multi-cluster/cluster-$c.yml"
  echo "Creating extravars file $filename"
  # Increment the node numbers.
  masternumber=$(($masternumber+3))
  firstnodenumber=$(($masternumber+1))
  secondnodenumber=$(($masternumber+2))
  # Create the extra vars we need.
  cat <<EOF > $filename
hugepages_enabled: true
image_destination_name: bootstrapped.qcow2
spare_disk_attach: false
pod_network_type: "none"
# bridge_networking: true
# bridge_name: br0
# bridge_physical_nic: "enp1s0f1"
# bridge_network_name: "br0"
# bridge_network_cidr: 192.168.1.0/24
virtual_machines:
  - name: kube-master-$masternumber
    node_type: master
    system_ram_mb: 4096
  - name: kube-node-$firstnodenumber
    node_type: nodes
    system_ram_mb: 4096
  - name: kube-node-$secondnodenumber
    node_type: nodes
    system_ram_mb: 4096
enable_userspace_cni: true
EOF
done

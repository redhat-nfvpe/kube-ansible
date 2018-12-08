#!/bin/bash

# Usage: ./contrib/multi-cluster/extravars-creator.sh $number_of_clusters

# Alright what do we need...
# 1. We need to generate inventories..

echo "Warning: You're about to delete the existing extravars files!"
# sleep 2

rm -Rf ./inventory/multi-cluster
mkdir -p ./inventory/multi-cluster

masternumber=-2
ip_master=47

for (( c=1; c<=$1; c++ ))
do
  filename="./inventory/multi-cluster/cluster-$c.yml"
  echo "Creating extravars file $filename"
  # Increment the node numbers.
  masternumber=$(($masternumber+3))
  firstnodenumber=$(($masternumber+1))
  secondnodenumber=$(($masternumber+2))
  ip_master=$(($ip_master+3))
  ip_first=$(($ip_master+1))
  ip_second=$(($ip_master+2))
  # Create the extra vars we need.
  cat <<EOF > $filename
kubeadm_version: v1.11.2
hugepages_enabled: true
image_destination_name: bootstrapped.qcow2
spare_disk_attach: false
pod_network_type: "none"
enable_compute_device: true
customize_kube_config: true
network_type: "extra_interface"
system_network: 192.168.122.0
system_netmask: 255.255.255.0
system_broadcast: 192.168.122.255
system_gateway: 192.168.122.1
system_nameservers: 192.168.122.1
system_dns_search: example.com
# ignore_preflight_version: true
# bridge_networking: true
# bridge_name: br0
# bridge_physical_nic: "enp1s0f1"
# bridge_network_name: "br0"
# bridge_network_cidr: 192.168.1.0/24
virtual_machines:
  - name: kube-master-$masternumber
    node_type: master
    system_ram_mb: 4096
    system_cpus: 1
    static_ip: 192.168.122.$ip_master
  - name: kube-node-$firstnodenumber
    node_type: nodes
    system_ram_mb: 4096
    system_cpus: 1
    static_ip: 192.168.122.$ip_first
#  - name: kube-node-$secondnodenumber
#    node_type: nodes
#    system_ram_mb: 4096
#    system_cpus: 1
#    static_ip: 192.168.122.$ip_second
enable_userspace_cni: true
EOF
done

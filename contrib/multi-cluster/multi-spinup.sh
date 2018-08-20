#!/bin/bash

# First argument is number of clusters. See README.md for more details.

for (( c=1; c<=$1; c++ ))
do
  filename="./inventory/multi-cluster/cluster-$c.yml"
  cmd="ansible-playbook -i inventory/virthost.inventory -e \"@$filename\" playbooks/virthost-setup.yml"
  echo Running: $cmd
  eval $cmd
  mv inventory/vms.local.generated ./inventory/multi-cluster/cluster-$c.inventory
  echo "New inventory @ ./inventory/multi-cluster/cluster-$c.inventory"
done
#!/bin/bash

# First argument is number of clusters. See README.md for more details.

for (( c=1; c<=$1; c++ ))
do
  extravars="./inventory/multi-cluster/cluster-$c.yml"
  cmd="ansible-playbook -i inventory/virthost.inventory -e \"@$extravars\" playbooks/vm-teardown.yml"
  echo Running: $cmd
  eval $cmd
done
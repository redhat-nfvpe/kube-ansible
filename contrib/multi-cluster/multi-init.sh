#!/bin/bash

# First argument is number of clusters. See README.md for more details.

for (( c=1; c<=$1; c++ ))
do
  extravars="./inventory/multi-cluster/cluster-$c.yml"
  inventory="./inventory/multi-cluster/cluster-$c.inventory"
  cmd="ansible-playbook -i \"$inventory\" -e \"@$extravars\" playbooks/kube-init.yml"
  echo Running: $cmd
  eval $cmd
done
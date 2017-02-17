# kube-centos-ansible

Install kubernetes 1.5 on a cluster of CentOS VMs, including CNI pod networking using Weave.

## Want some more detail?

This document is... Kind of terse. Want a complete walkthrough? Check out my [blog article detailing how to get it going from scratch](http://dougbtv.com/nfvpe/2017/02/16/kubernetes-1.5-centos/).

## Playbooks

| Playbook              | Inventory                        | Purpose                                            |
|-----------------------|----------------------------------|----------------------------------------------------|
| `virt-host-setup.yml` | `./inventory/virthost.inventory` | Provision a virtual machine host                   |
| `kube-install.yml`    | `./inventory/vms.inventory`      | Install and configure a k8s cluster                |
| `kube-teardown.yml`   | `./inventory/vms.inventory`      | Runs `kubeadm reset` on all nodes to tear down k8s |
| `vm-teardown.yml`     | `./inventory/virthost.inventory` | Destroys VMs on the virtual machine host           |


*(Table generated with [markdown tables](http://www.tablesgenerator.com/markdown_tables))*

## Usage

Step 1. Modify `./inventory/virthost.inventory` to setup a virt host (skip to step 2 if you already have an inventory)

```
ansible-playbook -i inventory/virthost.inventory virt-host-setup.yml 
```

Step 2. Modify `./inventory/vms.inventory` Setup kube on all the hosts. If you used step 1, towards the end of the output there there will be hints on which IPs for each VM created.

```
ansible-playbook -i inventory/vms.inventory kube-install.yml
```

Want more VMs? Edit the `./vars/all.yml` and add them to the list (and then later to your inventory in step 2)

## About

Initially inspired by:

* [k8s 1.5 on Centos](http://linoxide.com/containers/setup-kubernetes-kubeadm-centos/)
* [kubeadm getting started](https://kubernetes.io/docs/getting-started-guides/kubeadm/)




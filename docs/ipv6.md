## Setting up an IPv6 Lab using kube-ansible

This document covers a simple setup of using kube-ansible for spinning up an
IPv6 laboratory based in part by this [customized release of
Kubernetes](https://github.com/leblancd/kubernetes/releases/tag/v1.9.0-alpha.1.ipv6.1b)
created by [leblancd](https://github.com/leblancd) and automated herein by
[fepan](https://github.com/fepan).

In part this document assumes some other familiarity with these Ansible
playbooks. In theory you should be able to spin up just an IPv6 lab without
otherwise having experience with this playbook. However, some of the
terminology may be glossed over. We often use the term "virthost" -- by which
we mean a host that runs virtual machines. This technique is used often by the
developers of this project in order to quickly iterate on these playbooks.
These instructions assume using a virthost, however, it's likely you could
complete a deployment on baremetal, or on an IaaS.

## Limitations

Currently, this setup makes it possible to `ping6` one pod from another. We
look forward to using this laboratory to explore the other possibilities and
scenarios herein, however this pod-to-pod `ping6` is the baseline functionality
from which to start.

## Requirements

To run these playbooks, it's assumed that you have:

* A machine for running Ansible (like your workstation) and [have Ansible
  installed](http://docs.ansible.com/ansible/latest/intro_installation.html).
* Ansible 2.4 or later (necessary to support `get_url` with IPv6 enabled
  machines)
* A host capable of running virtual machines, and is running CentOS 7.
* A clone of this repository.

This scenario disables the "bridged networking" feature we often use and
instead uses NAT'ed libvirt virtual machines. 

You may have to disable GRO ([generic receive
offload](https://en.wikipedia.org/wiki/Large_receive_offload)) for the NICs on
the virtualization host (if you're using one).

An example of doing so is:

```
ethtool -K em3 gro off
```

## Inventory and variable setup

Firstly, let's look at an inventory and variable overrides to use.

Here's the initially used inventory, which only really cares about the
`virthost`. These examples place the inventory file @
`inventory/your.virthost.inventory`. You'll need to modify the location of the
host to match your environment.

```
the_virthost ansible_host=192.168.1.119 ansible_ssh_user=root

[virthost]
the_virthost
```

And the overrides which are based on the examples @
`./inventory/examples/virthost/virthost-ipv6.inventory.yml`. In these examples
this set of extra variables was created @ `./inventory/extravars.yml` (you may
otherwise place it and use it in another fashion should you please):

```
bridge_networking: false
virtual_machines:
  - name: kube-master
    node_type: master
  - name: kube-node-1
    node_type: nodes
  - name: kube-node-2
    node_type: nodes
  - name: kube-nat64-dns64
    node_type: other
ipv6_enabled: true
```


## Spinning up and access virtual machines

Perform a run of the `virthost-setup.yml` playbook, using the previously
mentioned extra variables for override, and an inventory which references the 

```
ansible-playbook -i inventory/your.virthost.inventory -e "@./inventory/extravars.yml" virthost-setup.yml
```

This will produce an inventory file in the local clone of this repo @
`./inventory/vms.local.generated`.

In the case that you're running Ansible from your workstation, and your
virthost is another machine, you may need to SSH jump host from the virthost to
the virtual machines.

If that is the case, you may add to the bottom of
`./inventory/vms.local.generated` a line similar to this (replacing
`root@192.168.1.119` with the method you use to access the virtualization
host):

```
cat << EOF >> ./inventory/vms.local.generated
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p root@192.168.1.119"'
EOF
```

### Optional: Handy-dandy "ssh to your virtual machines script"

You may wish to log into to the machines in order to debug, or even more likely
-- to access the Kubernetes master after an install.

You may wish to create a script, in this example... This script is located at
`~/jumphost.sh` and you should change `192.168.1.119` to the hostname or IP
address of your `virthost`.

```
# !/bin/bash
ssh -i ~/.ssh/the_virthost/id_vm_rsa -o ProxyCommand="ssh root@192.168.1.119 nc $1 22" centos@$1
```

You would use this script by calling it with `~/jumphost.sh yourhost.local`
where the first parameter to the script is the hostname or IP address of the
virtual machine you wish to acess.

Here's an example of using it to access the kubernetes master by pulling the IP
address from the generated inventory:

```
$ ~/jumphost.sh $(cat inventory/vms.local.generated | grep "kube-master.ansible" | cut -d"=" -f 2)
```

## Deploy a Kubernetes cluster

With the above in place, we can now perform a kube install, and use the locally
generated inventory.

```
ansible-playbook -i inventory/vms.local.generated -e "@./inventory/extravars.yml" kube-install.yml
```

You now should SSH to the master, and if you please, check out the status of
the cluster with `kubectl get nodes` and/or `kubectl cluster-info`.

We'll now create a couple pods via a ReplicationController. Create a YAML
resource definition like so:

```
[centos@kube-master ~]$ cat debug.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: debugging
spec:
  replicas: 2
  selector:
    app: debugging
  template:
    metadata:
      name: debugging
      labels:
        app: debugging
    spec:
      containers:
      - name: debugging
        command: ["/bin/bash", "-c", "sleep 2000000000000"]
        image: dougbtv/centos-network-advanced
        ports:
        - containerPort: 80
```

Create the pods with `kubectl` by issuing:

```
$ kubectl create -f debug.yaml
```

You may then wish to watch the pods come up:

```
[centos@kube-master ~]$ watch -n1 kubectl get pods -o wide
```

Once those pods are fully running, list them, and take a look at the IP
addresses, like so:

```
[centos@kube-master ~]$ kubectl get pods -o wide
NAME              READY     STATUS    RESTARTS   AGE       IP            NODE
debugging-cvbb2   1/1       Running   0          4m        fd00:101::2   kube-node-1
debugging-gw8xt   1/1       Running   0          4m        fd00:102::2   kube-node-2
```

Now you can exec commands in one of them, to ping the other:

```
[centos@kube-master ~]$ kubectl exec -it debugging-cvbb2 -- /bin/bash -c 'ping6 -c5 fd00:102::2'
PING fd00:102::2(fd00:102::2) 56 data bytes
64 bytes from fd00:102::2: icmp_seq=1 ttl=62 time=0.845 ms
64 bytes from fd00:102::2: icmp_seq=2 ttl=62 time=0.508 ms
64 bytes from fd00:102::2: icmp_seq=3 ttl=62 time=0.562 ms
64 bytes from fd00:102::2: icmp_seq=4 ttl=62 time=0.357 ms
64 bytes from fd00:102::2: icmp_seq=5 ttl=62 time=0.555 ms
```

Finally pat yourself on the back and enjoy some IPv6 goodness.

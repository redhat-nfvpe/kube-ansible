# kube-ansible

`kube-ansible` is a set of Ansible playbooks and roles that allows
you to instantiate a vanilla Kubernetes cluster on (primarily) CentOS virtual
machines or baremetal.

Additionally, kube-ansible includes CNI pod networking (defaulting to Flannel,
with an ability to deploy Weave and Multus).

The purpose of kube-ansible is to provide a simpler lab environment that allows
prototyping and proof of concepts. For staging and production deployments, we
recommend that you utilize
[OpenShift-Ansible](https://github.com/openshift/openshift-ansible)

## Playbooks

Playbooks are located in the `playbooks/` directory.

| Playbook                         | Inventory                             | Purpose                                                            |
| -------------------------------- | ------------------------------------- | ------------------------------------------------------------------ |
| `virt-host-setup.yml`            | `./inventory/virthost/`               | Provision a virtual machine host                                   |
| `kube-install.yml`               | `./inventory/vms.local.generated`     | Install and configure a k8s cluster                                |
| `kube-teardown.yml`              | `./inventory/vms.local.generated`     | Runs `kubeadm reset` on all nodes to tear down k8s                 |
| `vm-teardown.yml`                | `./inventory/virthost/`               | Destroys & removes VMs on the virtual machine host                           |
| `multus-cni.yml`                 | `./inventory/vms.local.generated`     | Compiles [multus-cni](https://github.com/Intel-Corp/multus-cni)    |
| `gluster-install.yml`            | `./inventory/vms.local.generated`     | Install a GlusterFS cluster across VMs (requires vm-attach-disk)   |
| `fedora-python-bootstrapper.yml` | `./inventory/vms.local.generated`     | Bootstrapping Python dependencies on cloud images                  |
| builder.yml                      | ./inventory/vms.local.generated       | Build a Kubernetes release in a dedicated virtual machine          |

*(Table generated with [markdown tables](http://www.tablesgenerator.com/markdown_tables))*

## Overview

kube-ansible provides the means to install and setup KVM as a virtual host
platform on which virtual machines can be created, and used as the foundation
of a Kubernetes cluster installation.

![kube-ansible Topology Overview](docs/images/kube-ansible_overview.png)

There are generally two steps to this deployment:

* Installation of KVM on the baremetal system and virtual machine instantiation
* Kubernetes environment installed and setup on the virtual machines

First we start by configuring our `virthost/` inventory to match our working
environment, including DNS or IP address of the baremetal system that we'll
install KVM onto. We also setup our network (KVM network, whether that be a
bridged interface, or a NAT interface), and then define the system topology
we're going to deploy (number of virtual machines to instantiate).

We do this with the `virthost-setup.yml` playbook, which performs the virtual
host basic configuration, virtual machine instantiation, and extra virtual disk
creation when configuring persistent storage with GlusterFS.

During the `virthost-setup.yml` a `vms.local.generated` inventory file is
created with the IP addresses and hostname of the virtual machines. The
`vms.local.generated` file can then be used with `kube-install.yml`.

## Usage

### Step 0. Install dependent roles

Install role dependencies with `ansible-galaxy`.

```
ansible-galaxy install -r requirements.yml
```

### Step 1. Create virtual host inventory

Copy the example `virthost` inventory into a new directory.

```
cp -r inventory/examples/virthost inventory/virthost/
```

### Step 2. Setup virtual host inventory

Modify `./inventory/virthost/virthost.inventory` to setup a virtual
host (skip to step 3 if you already have an inventory).

Want more VMs? Edit `inventory/virthost/group_vars/virthost.yml` and add an
override list via `virtual_machines` (template in
`roles/ka-init/group_vars/all.yml`). You can also define separate vCPU and vRAM
for each of the virtual machines with `system_ram_mb` and `system_cpus`. The
default values are setup via `system_default_ram_mb` and `system_default_cpus`
which can also be overridden if you wish different default values. (Current
defaults are 2048MB and 4 vCPU.)

> **WARNING**
>
> If you're not going to be connecting to the virtual machines from the same
> network as your source machine, you'll need to make sure you setup the
> `ssh_proxy_enabled: true` and other related `ssh_proxy_...` variables to
> allow the `kube-install.yml` playbook to work properly. See next **NOTE** for
> more information.

**Running on virthost directly**
```
ansible-playbook -i inventory/virthost/ playbooks/virthost-setup.yml
```

**Setting up virthost as a jump host**
```
ansible-playbook -i inventory/virthost/ -e ssh_proxy_enabled=true playbooks/virthost-setup.yml
```

> **NOTE**
>
> There are a few extra variables you may wish to set against the virtual host
> which can be satisfied in the `inventory/virthost/group_vars/virthost.yml`
> file of your local inventory configuration in `inventory/virthost/` that you
> just created.
>
> Primarily, this is for overriding the default variables located in the
> `roles/ka-init/group_vars/all.yml` file, or overriding the default values
> associated with the roles.
>
> Some common variables you may wish to override include:
>
> * `bridge_networking: false`  _disable bridge networking setup_
> * `images_directory: /home/images/kubelab`  _override image directory
>   location_
> * `spare_disk_location: /home/images/kubelab`  _override spare disk location_
>
> The following values are used in the generation of the dynamic inventory file
> `vms.local.generated`
>
> * `ssh_proxy_enabled: true`  _proxy via jump host (remote virthost)_
> * `ssh_proxy_user: root`  _username to SSH into virthost_
> * `ssh_proxy_host: virthost`  _hostname or IP of virthost_
> * `ssh_proxy_port: 2222` _port of the virthost (optional, default 22)_
> * `vm_ssh_key_path: /home/lmadsen/.ssh/id_vm_rsa`  _path to local SSH key_


### Step 3. Install Kubernetes

During the execution of _Step 1_ a local inventory should have been
generated for you called `inventory/vms.local.generated` that contains the
hosts and their IP addresses. You should be able to pass this inventory to the
`kube-install.yml` playbook.

> **NOTE**
>
> If you're not running the Ansible playbooks from the virtual host itself,
> it's possible to connect to the virtual machines via SSH proxy. You can do
> this by setting up the `ssh_proxy_...` variables as noted in _Step 2_.

Alternatively you can ignore the generated inventory and copy the example
inventory directory from `inventory/examples/vms/` and modify to your hearts
content.

```
ansible-playbook -i inventory/vms.local.generated playbooks/kube-install.yml
```

Once you've done that, you should be able to connect to your Kubernetes master
virtual machine and run `kubectl get nodes` and see that all your nodes are in
a _Ready_ state. (It may take some time for everything to coalesce and the
nodes to report back to the Kubernetes master node.)

In order to login to the nodes, you may need to `ssh-add
~/.ssh/vmhost/id_vm_rsa`. The private key created on the virtual host will be
automatically fetched to your local machine, allowing you to connect to the
nodes when proxying.

> **Pro Tip**
>
> You can create a `~/.bashrc` alias to SSH into the virtual machines if you're
> not executing the Ansible playbooks directly from your virtual host (i.e.
> from your laptop or desktop). To SSH into the nodes via SSH proxy, add the
> following alias:
>
> ```
> alias ssh-virthost='ssh -o ProxyCommand="ssh -W %h:%p root@virthost"'
> ```
> It's assumed you're logging into the virtual host as the `root` user and at
> hostname `virthost`. Change as required.
>
> **Usage**: `source ~/.bashrc ; ssh-virthost centos@kube-master`

### Step 4. Checking your installation

Once you're logged into your Kubernetes master node, run the following command
to check the state of your cluster.

```
kubectl get nodes
NAME          STATUS    ROLES     AGE       VERSION
kube-master   Ready     master    10m       v1.8.3
kube-node-1   Ready     <none>    9m        v1.8.3
kube-node-2   Ready     <none>    9m        v1.8.3
kube-node-3   Ready     <none>    9m        v1.8.3
```

Everything should be marked as ready. If so, you're good to go!

## Creating a bootstrapped image

Should you need to spin up multiple clusters or otherwise spin up a bunch of VMs for a cluster, it may behoove you to "bootstrap" your VM images so that you don't have to download the dependencies many times. You can create a sort of golden image to use by using the `./playbooks/create-bootstrapped-image.yml` playbook.

You can run it for example like so:

```
$ ansible-playbook -i inventory/virthost.inventory \
  -e "@./inventory/examples/image-bootstrap/extravars.yml" \
  playbooks/create-bootstrapped-image.yml
```

This will result in an image being created @ `/home/images/bootstrapped.qcow2` (by default, this can be altered otherwise). You can then specify this image to use when creating a cluster.

For example...



# About

Initially inspired by:

* [k8s 1.5 on Centos](http://linoxide.com/containers/setup-kubernetes-kubeadm-centos/)
* [kubeadm getting started](https://kubernetes.io/docs/getting-started-guides/kubeadm/)

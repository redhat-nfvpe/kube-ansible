# kube-ansible

`kube-ansible` is a set of Ansible playbooks and roles that allows
you to instantiate a vanilla Kubernetes cluster on (primarily) CentOS virtual
machines or baremetal.

Additionally, kube-ansible includes CNI pod networking (defaulting to Flannel,
with an ability to deploy Weave, Multus and OVN Kubernetes).

The purpose of kube-ansible is to provide a simpler lab environment that allows
prototyping and proof of concepts. For staging and production deployments, we
recommend that you utilize
[OpenShift-Ansible](https://github.com/openshift/openshift-ansible)

## Playbooks

Playbooks are located in the `playbooks/` directory.

| Playbook                                 | Inventory                             | Purpose                                                            |
| ---------------------------------------- | ------------------------------------- | ------------------------------------------------------------------ |
| `virthost-setup.yml`                     | `./inventory/virthost/`               | Provision a virtual machine host                                   |
| `bmhost-setup.yml`                       | `./inventory/bmhost/`                 | Provision a bare metal host and add to group nodes.                |
| `allhost-setup.yml`                      | `./inventory/allhosts/`               | Provision both a virtual machine host and a bare metal host.       |
| `kube-install.yml`                       | `./inventory/all.local.generated`     | Install and configure a k8s cluster using all hosts in group nodes |
| `kube-install-ovn.yml`                   | `./inventory/all.local.generated`     | Install and configure a k8s cluster with OVN network using all hosts in group nodes |
| `kube-teardown.yml`                      | `./inventory/all.local.generated`     | Runs `kubeadm reset` on all nodes to tear down k8s                 |
| `vm-teardown.yml`                        | `./inventory/virthost/`               | Destroys VMs on the virtual machine host                           |
| `fedora-python-bootstrapper.yml`         | `./inventory/vms.local.generated`     | Bootstrapping Python dependencies on cloud images                  |

*(Table generated with [markdown tables](http://www.tablesgenerator.com/markdown_tables))*

## Overview

kube-ansible provides the means to install and setup KVM as a virtual host
platform on which virtual machines can be created, and used as the foundation
of a Kubernetes cluster installation.

![kube-ansible Topology Overview](docs/images/kube-ansible_overview.png)

There are generally two steps to this deployment:

* Installation of KVM on the baremetal system and virtual machines instantiation
* Kubernetes environment installation and setup on the virtual machines

Start with configuring the `virthost/` inventory to match the required working
environment, including DNS or IP address of the baremetal system, that will be
installed and configured on the KVM platform. It also setup the network (KVM
network, whether that be a bridged interface, or a NAT interface), and then
define the system topology that needs to be deployed (e.g number of virtual
machines to instantiate).

All the above mentioned configuration is done by `virthost-setup.yml` playbook,
which performs the virtual host basic configuration, virtual machine
instantiation, and extra virtual disk creation when configuring persistent
storage with GlusterFS.

During the `virthost-setup.yml` a `vms.local.generated` inventory file is
created with the IP addresses and hostname of the virtual machines. The
`vms.local.generated` file can then be used with Kubernetes installation
playbooks like `kube-install.yml` or `kube-install-ovn.yml`.

## Usage

### Step 0. Install dependent roles

Install role dependencies with `ansible-galaxy`. This step will install the main
dependencies like (go and docker) and also brings other roles that is required
for setting up the VMs.

```
ansible-galaxy install -r requirements.yml
```

### Step 1. Create virtual host inventory

Copy the example `virthost` inventory into a new directory.

```
cp -r inventory/examples/virthost inventory/virthost/
```
Modify `./inventory/virthost/virthost.inventory` to setup a virtual
host (If inventory is already present, please skip this step).

### Step 2. Override the default configuration if requires
All the default configuration settings used by kube-ansible playbooks are present
 in the [all.yml](playbooks/ka-init/group_vars/all.yml) file.

For instance by default kube-ansible creates one master and two worker node setup
 only (please refer to ordered list under `virtual_machines` in [all.yml](playbooks/ka-init/group_vars/all.yml)),
 but if HA cluster deployment (stacked control plane nodes) is required,
 edit the [all.yml](playbooks/ka-init/group_vars/all.yml) file and change the
 configuration to something on the line of

   ```
   virtual_machines:
     - name: kube-lb
       node_type: lb
     - name: kube-master1
       node_type: master
     - name: kube-master2
       node_type: master_slave
     - name: kube-master3
       node_type: master_slave
     - name: kube-node-1
       node_type: nodes
     - name: kube-node-2
       node_type: nodes
   ```
Above configuration change will create 3 node HA cluster with 2 worker nodes and
 a LB node.

You can also define separate vCPU and vRAM for each of the virtual machines with
 `system_ram_mb` and `system_cpus`. The default values are setup via `system_default_ram_mb`
 and `system_default_cpus` which can also be overridden if you wish different
 default values. (Current defaults are 2048MB and 4 vCPU.)


> **WARNING**
>
> If you're not going to be connecting to the virtual machines from the same
> network as your source machine, you'll need to make sure you setup the
> `ssh_proxy_enabled: true` and other related `ssh_proxy_...` variables to
> allow the `kube-install.yml` playbook to work properly. See next **NOTE** for
> more information.

### Step 3. Create the virtual machines defined in [all.yml](./playbooks/ka-init/group_vars/all.yml)

Once the default configuration is being changed as per the setup requirements,
execute the following instruction to create the VMs and generate the final inventory
with all the details required for Kubernetes installation on these VMs.

> **NOTE**
>
> There are a few extra variables you may wish to set against the virtual host
> which can be satisfied in the `inventory/virthost/group_vars/virthost.yml`
> file of your local inventory configuration in `inventory/virthost/` that you
> just created.
>
> Primarily, this is for overriding the default variables located in the
> [all.yml](playbooks/ka-init/group_vars/all.yml) file, or overriding the default values
> associated with the roles.
>
> Some common variables you may wish to override include:
>
> * `bridge_networking: false`  _disable bridge networking setup_
> * `images_directory: /home/images/kubelab`  _override image directory
>   location_
> * `spare_disk_location: /home/images/kubelab`  _override spare disk location_
>
> The following values are used in the generation of the final inventory file
> `vms.local.generated`
>
> * `ssh_proxy_enabled: true`  _proxy via jump host (remote virthost)_
> * `ssh_proxy_user: root`  _username to SSH into virthost_
> * `ssh_proxy_host: virthost`  _hostname or IP of virthost_
> * `ssh_proxy_port: 2222` _port of the virthost (optional, default 22)_
> * `vm_ssh_key_path: /home/lmadsen/.ssh/id_vm_rsa`  _path to local SSH key_

**Running on virthost directly**
```
ansible-playbook -i inventory/virthost/ playbooks/virthost-setup.yml
```

**Setting up virthost as a jump host**
```
ansible-playbook -i inventory/virthost/ -e ssh_proxy_enabled=true playbooks/virthost-setup.yml
```

Both the commands above will generate a new inventory file `vm.local.generated`
in `inventory` directory. This inventory file will be used by the Kubernetes
installation playbooks to install Kubernetes on the provisioned VMs. For instance,
 below content is an example of `vm.local.generated` file for 3 node HA Kubernetes cluster

```
kube-lb ansible_host=192.168.122.31
kube-master1 ansible_host=192.168.122.117
kube-master2 ansible_host=192.168.122.160
kube-master3 ansible_host=192.168.122.143
kube-node-1 ansible_host=192.168.122.53
kube-node-2 ansible_host=192.168.122.60

[lb]
kube-lb

[master]
kube-master1

[master_slave]
kube-master2
kube-master3

[nodes]
kube-node-1
kube-node-2


[all:vars]
ansible_user=centos
ansible_ssh_private_key_file=/root/.ssh/dev-server/id_vm_rsa
```
> **Tip**
> User can override the configuration values from command line as well

```
 # ansible-playbook -i inventory/virthost.inventory -e 'network_type=2nics' playbooks/virthost-setup.yml
```

### Step 4. Install Kubernetes on the instantiated virtual machines

During the execution of _Step 3_ a local inventory file `inventory/vms.local.generated`
 should have been generated. This inventory file contains the virtual machines and their
 IP addresses. Alternatively you can ignore the generated inventory and copy the example
 inventory directory from `inventory/examples/vms/` and modify to your hearts
 content.

This inventory file need to be passed to the Kubernetes Installation playbooks
(`kube-install.yml \ kube-install-ovn.yml`).


```
ansible-playbook -i inventory/vms.local.generated playbooks/kube-install.yml
```

> **NOTE**
>
> If you're not running the Ansible playbooks from the virtual host itself,
> it's possible to connect to the virtual machines via SSH proxy. You can do
> this by setting up the `ssh_proxy_...` variables as noted in _Step 3_.

#### Options

kube-ansible supports following options and these options can be configured in [all.yml](playbooks/ka-init/group_vars/all.yml):

- `network_type` (optional, string): specify network topology for the virthost, each master/worker has one interface (eth0) in default:
  - `2nics`: each master/worker node has two interfaces: eth0 and eth1
  - `bridge`: add linux bridge (`cni0`) and move `eth0` under `cni0`. This is useful to use linux bridge CNI for Kubernetes Pod's network
- `container_runtime` (optional, string): specify container runtime that Kubernetess uses. Default uses Docker.
  - `crio`: install [cri-o](https://cri-o.io/) for the container runtime
- `crio_use_copr` (optional, boolean): (only in case of cri-o) set true if [copr cri-o RPM](http://copr.fedorainfracloud.org/coprs/s1061123/cri-o) is used
- `ovn_image_repo` (optional, string): set the container image (e.g. `docker.io/ovnkube/ovn-daemonset-u:latest`)
- `enable_endpointslice` (optional, boolean): set `True` if endpointslice is used instead of endpoints
- `enable_auditlog` (optional, boolean): set `True` if auditing logs
- `enable_ovn_raft` (optional, boolean): (`kube-install-ovn.yml` only) set `True` if you want to OVN with raft mode
- `ovn_image_repo` (optional, string): Replace the url if image needs to be pull from other location.

> **NOTE**
>
> In case of `enable_ovn_raft=True`, you need to build your own image from the upstream `ovn-kubernetes`
> repo and push it to your account and configure `ovn_image_repo` to point to that newly built image,
> because current official ovn-kubernetes image does not support raft.

**Tip**
User can override the [all.yml](playbooks/ka-init/group_vars/all.yml) configuration values from command line
as well. Here's the example:

- Install Kubernetes with cri-o runtime, each host has two NICs (eth0, eth1):

```
# ansible-playbook -i inventory/vms.local.generated -e 'network_type=2nics' -e 'container_runtime=crio' playbooks/kube-install.yml
```

Once ansible-playbook execute successfully, to verify the installation login to the Kubernetes master
virtual machine and run `kubectl get nodes` and verify that all the nodes are in a _Ready_ state.
(It may take some time for everything to coalesce and the nodes to report back to the Kubernetes master node.)

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

### Step 5. Checking your installation

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

## Example Setup and configuration instructions
Following instructions are to create a HA Kubernetes cluster with two worker nodes and `OVN-Kubernetes`
in Raft mode as a CNI. All these instructions are executed from the physical server where virtual virtual_machines
will be created to deploy the Kubernetes cluster.

**Install requirements**

```
ansible-galaxy install -r requirements.yml
```

**Create inventory**
```
cp -r inventory/examples/virthost inventory/virthost/
```
**Configure inventory**
Content of `inventory/virthost/virthost.inventory`
```
dev-server ansible_host=127.0.0.1 ansible_ssh_user=root
[virthost]
dev-server
```
**Configure default values**
Overridden configuration values in [all.yml](playbooks/ka-init/group_vars/all.yml)
```
container_runtime: crio
virtual_machines:
  - name: kube-master1
    node_type: master
  - name: kube-node-1
    node_type: nodes
  - name: kube-node-2
    node_type: nodes
# Uncomment following (lb/master_slave) for k8s master HA cluster
  - name: kube-lb
    node_type: lb
  - name: kube-master2
    node_type: master_slave
  - name: kube-master3
    node_type: master_slave

ovn_image_repo: "docker.io/avishnoi/ovn-kubernetes:latest"
enable_ovn_raft: True
```

**Create Virtual Machines for Kubernetes deployment and generate final inventory**
```
ansible-playbook -i inventory/virthost/ playbooks/virthost-setup.yml
```
This playbook creates required VMs and generate the final inventory file (`vms.local.generated`).
`virsh list` lists all the created VMs.

```
# virsh list
 Id    Name                           State
----------------------------------------------------
 4     kube-master1                   running
 5     kube-node-1                    running
 6     kube-node-2                    running
 7     kube-lb                        running
 8     kube-master2                   running
 9     kube-master3                   running
```

Generated `vms.local.generated` file
```
# cat ./inventory/vms.local.generated
kube-lb ansible_host=192.168.122.31
kube-master1 ansible_host=192.168.122.117
kube-master2 ansible_host=192.168.122.160
kube-master3 ansible_host=192.168.122.143
kube-node-1 ansible_host=192.168.122.53
kube-node-2 ansible_host=192.168.122.60

[lb]
kube-lb

[master]
kube-master1

[master_slave]
kube-master2
kube-master3

[nodes]
kube-node-1
kube-node-2


[all:vars]
ansible_user=centos
ansible_ssh_private_key_file=/root/.ssh/dev-server/id_vm_rsa
```
**Install Kubernetes**

```
ansible-playbook -i inventory/vms.local.generated playbooks/kube-install.yml
```
**Verify Setup**
Login to Kubernets master node
```
ssh -i ~/.ssh/dev-server/id_vm_rsa centos@kube-master1
```

Verify that all the nodes join the cluster

```
[centos@kube-master1 ~]$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
kube-master1   Ready    master   18h   v1.17.3
kube-master2   Ready    master   18h   v1.17.3
kube-master3   Ready    master   18h   v1.17.3
kube-node-1    Ready    <none>   18h   v1.17.3
kube-node-2    Ready    <none>   18h   v1.17.3

$ kubectl version
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.3", GitCommit:"06ad960bfd03b39c8310aaf92d1e7c12ce618213", GitTreeState:"clean", BuildDate:"2020-02-11T18:14:22Z", GoVersion:"go1.13.6", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.3", GitCommit:"06ad960bfd03b39c8310aaf92d1e7c12ce618213", GitTreeState:"clean", BuildDate:"2020-02-11T18:07:13Z", GoVersion:"go1.13.6", Compiler:"gc", Platform:"linux/amd64"}
```


# About

Initially inspired by:

* [k8s 1.5 on Centos](http://linoxide.com/containers/setup-kubernetes-kubeadm-centos/)
* [kubeadm getting started](https://kubernetes.io/docs/getting-started-guides/kubeadm/)

# Kucean

Install a kubernetes cluster on CentOS VMs (or baremetal), including CNI pod
networking (defaults to Flannel, also has ability to deploy Weave and Multus).

kube-centos-ansible is the project name, which can be compactly referred to as
_kucean_ i.e. (ku)bernetes-(ce)ntos-(an)sible

**kucean** p. koo-see-ehn

## Want some more detail?

This document is... Kind of terse. Want a complete walkthrough? Check out my
[blog article detailing how to get it going from scratch](http://dougbtv.com/nfvpe/2017/02/16/kubernetes-1.5-centos/).

## Playbooks

| Playbook              | Inventory                         | Purpose                                                          |
|-----------------------|-----------------------------------|------------------------------------------------------------------|
| `virt-host-setup.yml` | `./inventory/virthost/`           | Provision a virtual machine host                                 |
| `kube-install.yml`    | `./inventory/vms.local.generated` | Install and configure a k8s cluster                              |
| `kube-teardown.yml`   | `./inventory/vms.local.generated` | Runs `kubeadm reset` on all nodes to tear down k8s               |
| `vm-teardown.yml`     | `./inventory/virthost/`           | Destroys VMs on the virtual machine host                         |
| `multus-cni.yml`      | `./inventory/vms.local.generated` | Compiles [multus-cni](https://github.com/Intel-Corp/multus-cni)  |
| `gluster-install.yml` | `inventory/vms.local.generated`   | Install a GlusterFS cluster across VMs (requires vm-attach-disk) |


*(Table generated with [markdown tables](http://www.tablesgenerator.com/markdown_tables))*

## Usage

Step 1. Copy the example virthost inventory into a new directory

```
cp -r inventory/examples/virthost inventory/virthost
```

Step 2. Modify `./inventory/virthost/virthost.inventory` to setup a virtual
host (skip to step 3 if you already have an inventory)

> **NOTE**
>
> There are a few extra variables you may wish to set against the virtual host
> which can be satisfied in the `inventory/virthost/host_vars/virthost.yml`
> file of your local inventory configuration in `inventory/virthost/` that you
> just created.
>
> Primarily, this is for overriding the default variables located in the
> `group_vars/all.yml` file, or overriding the default values associated with
> the roles.
>
> Some common variables you may wish to override include:
>
> * `bridge_networking: false`  _disable bridge networking setup_
> * `images_directory: /home/images/kubelab`  _override image directory
>   location_
> * `spare_disk_location: /home/images/kubelab`  _override spare disk location_
>
> The following values are used in the generation of the dynamic inventory file
> `vms.inventory.generated`
>
> * `ssh_proxy_enabled: true`  _proxy via jump host (remote virthost)_
> * `ssh_proxy_user: root`  _username to SSH into virthost_
> * `ssh_proxy_host: virthost`  _hostname or IP of virthost_
> * `ssh_proxy_port: 2222` _port of the virthost (optional, default 22)_
> * `vm_ssh_key_path: /home/lmadsen/.ssh/id_vm_rsa`  _path to local SSH key_

```
ansible-playbook -i inventory/virthost/ virt-host-setup.yml
```

Step 3. During the execution of _Step 1_ a local inventory should have been
generated for you called `inventory/vms.local.generated` that contains the
hosts and their IP addresses. You should be able to pass this inventory to the
`kube-install.yml` playbook.

Alternatively you can ignore the generated inventory and copy the example
inventory directory from `inventory/examples/vms/` and modify to your hearts
content.

```
ansible-playbook -i inventory/vms.local.generated kube-install.yml
```


Want more VMs? Edit the `inventory/virthost/host_vars/virthost.yml` and add
an override list via `virtual_machines` (template in `group_vars/all.yml`).


### Setting a specific version

You may optionally set the `kube_version` variable to install a specific
version. This version number comes from a `yum search kubelet
--showduplicates`. For example:

```
ansible-playbook -i inventory/vms.local.generated kube-install.yml -e 'kube_version=1.6.7-0'
```

## Install specific binaries

By default, we install the kubelet (and `kubeadm`, `kubectl` and the core CNI plugins) via RPM. However, if you'd like to install specific binaries for either the kubelet, kubeadm or kubetl -- you can do so by specifying that you'd like to perform a binary install and specify URLs (that point to, say, binaries in a GitHub release).

There are sample variables provided in the `./group_vars/all.yml` file, and you can set them up such as:

```
binary_install: true
binary_kubectl_url: https://github.com/leblancd/kubernetes/releases/download/v1.9.0-alpha.1.ipv6.1b/kubectl
binary_kubeadm_url: https://github.com/leblancd/kubernetes/releases/download/v1.9.0-alpha.1.ipv6.1b/kubeadm
binary_kubelet_url: https://github.com/leblancd/kubernetes/releases/download/v1.9.0-alpha.1.ipv6.1b/kubelet
binary_install_force_redownload: false
```

## Using CRI-O

You can also enable [CRI-O](http://cri-o.io/) to have an OCI compatible
runtime. Set the `container_runtime` variable in
`inventory/vms.local.generated` under `[all_vms:vars]` or as an extra var when
you run the playbook:

```
$ ansible-playbook -i inventory/vms.local.generated kube-install.yml -e 'container_runtime=crio'
```

Additionally, the compilation of CRI-O requires a beefier machine, memory-wise. It's recommended you spin up the machines with 4 gigs of ram or greater during the VM creation phase, should you use it. One may wish to add the parameters `-e "vm_parameters_ram_mb=4096"` to your playbook run of `virt-host-setup.yml`.

## Using Fedora

Use of Fedora is currently suggested should you require the use of Buildah. Buildah requires functionality in later Linux kernels that are unavailable in recent versions of CentOS.

Take a gander at the `./inventory/examples/crio/crio.inventory` for an example of how to override the proper variables to use Fedora.

## About

Initially inspired by:

* [k8s 1.5 on Centos](http://linoxide.com/containers/setup-kubernetes-kubeadm-centos/)
* [kubeadm getting started](https://kubernetes.io/docs/getting-started-guides/kubeadm/)

# Additional Scenarios and Usage

In addition to setting up a basic vanilla Kubernetes environment, Kucean
supports some additional overrides and technology changes, including deployment
of a specific version or binary of Kubernetes, or using CRI-O as a backend.

## IPv6 Laboratory

Using the `ipv6_enabled` variable set to true, you can set up a lab for testing IPv6. For more detailed instructions, visit the [IPv6 documentation contained in this repository](docs/ipv6.md).

## Setting a specific version

You may optionally set the `kube_version` variable to install a specific
version. This version number comes from a `yum search kubelet
--showduplicates`. For example:

```
ansible-playbook -i inventory/vms.local.generated \
    -e 'kube_version=1.6.7-0' \
    kube-install.yml
```

## Install specific binaries

By default, we install the kubelet (and `kubeadm`, `kubectl` and the core CNI
plugins) via RPM. However, if you'd like to install specific binaries for
either the kubelet, kubeadm or kubetl -- you can do so by specifying that you'd
like to perform a binary install and specify URLs (that point to, say, binaries
in a GitHub release).

There are sample variables provided in the `./group_vars/all.yml` file, and you
can set them up such as:

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
`inventory/vms.local.generated` under `[master:vars]` and `[nodes:vars]`, or as
an extra var when you run the playbook:

```
$ ansible-playbook -i inventory/vms.local.generated \
    -e 'container_runtime=crio' \
    kube-install.yml
```

Additionally, the compilation of CRI-O requires a beefier machine, memory-wise.
It's recommended you spin up the machines with 4 gigs of ram or greater during
the VM creation phase, should you use it. One may wish to add the parameters
`-e "system_default_ram_mb=4096"` to your playbook run of `virthost-setup.yml`.

## Using Fedora

Use of Fedora is currently suggested should you require the use of Buildah.
Buildah requires functionality in later Linux kernels that are unavailable in
recent versions of CentOS.

Take a gander at the `./inventory/examples/crio/crio.inventory` for an example
of how to override the proper variables to use Fedora.


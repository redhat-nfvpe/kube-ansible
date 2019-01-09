# Ansible Playbook to Build Open vSwitch with DPDK support

This playbook installs Open vSwitch with DPDK support.

## Quick Start
Ensure that you have [installed Ansible](http://docs.ansible.com/ansible/intro_installation.html) on the host where you want to run the playbook from.

This playbook has been tested against Fedora 22.

To run the playbook against a host 192.168.1.100 (note the comma following the host name/IP address must be included):

```bash 
$ git clone https://github.com/mixja/ansible-ovs-dpdk.git 
...
...
$ cd ansible-ovs-dpdk
ansible-dpdk-seastar$ ansible-playbook -i "192.168.1.100," site.yml
SSH password: *******

PLAY [Provision Custom Facts] *************************************************
...
...
```

## Changing Folder and Repo Settings

The `group_vars/all` file contains the following variables:

- `dpdk_dir` - root folder of the DPDK source
- `dpdk_build` - build folder for the DPDK source
- `dpdk_repo` - Git repo of the DPDK source
- `ovs_dir` - root folder of the OVS source
- `ovs_repo` - Git repo of the OVS source

## Changing Build Settings

The following variables can be used to force a rebuild or build a different version:

- `ovs_rebuild` - if set to any value, forces OVS to be built.
- `ovs_version` - specifies the branch, tag or commit hash to build.  If a change is detected from the current repo, OVS will be rebuilt.
- `dpdk_rebuild` - if set to any value, forces DPDK to be built.
- `dpdk_version` - specifies the branch, tag or commit hash to build.  If a change is detected from the current repo, DPDK will be rebuilt.
- `dpdk_device_name` - defines the device name to use for DPDK UIO/VFIO scripts.  The default value is `eno1` if not specified.

The following example forces DPDK to be built:

```bash
$ ansible-playbook -i "192.168.1.100," site.yml --extra-vars "dpdk_rebuild=true"
```

The following example checks out OVS commit abc1234 to be checked out and forces a build of OVS:

```bash
$ ansible-playbook -i "192.168.1.100," site.yml --extra-vars "ovs_rebuild=true ovs_version=abc1234"
``` 

## Testing OVS DPDK 

After DPDK and OVS are built you can use the following helper scripts:

### Load DPDK kernel module and bind network interface

Choose one of the following options:

- `/root/dpdk_uio.sh` - downs the network interface, inserts the UIO kernel module and binds DPDK to the network interface
- `/root/dpdk_vfio.sh` - downs the network interface, inserts the VFIO_PCI kernel module and binds DPDK to the network interface

### Init and start OVS

- `/root/start_ovsdb_server.sh` - starts OVSDB server
- `/root/start_ovs_vswitchd.sh` - starts OVS vswitchd with DPDK support enabled

### Create OVS bridges and ports

Create an OVS bridge with the datapath_type "netdev":

`ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev`

Add DPDK devices:

`ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk`

See the [OVS DPDK README](https://github.com/openvswitch/ovs/blob/master/INSTALL.DPDK.md) for further information.
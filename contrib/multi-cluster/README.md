# Multi-cluster creator!

A series of scripts designed to spin up multiple clusters at once. Originally designed for a tutorial / classroom setup where you're spinning up a cluster for each attendee to use.

These scripts are designed to be run from the root directory of this clone.

## Prerequisites

* A physical machine with CentOS 7
    - We call this machine "the virthost", it hosts your virtual machines
* On your client machine...
    - A clone of this repo
    - SSH keys to that physical machine that allow you to login as root (without a passowrd is convenient.)
    - Ansible. Tested with version 2.5.7

## General process

In overview, what we're going to do is:

* Setup the virtualization host ("virthost")
* Create a "bootstrap image" (a golden image from which VMs are created)
* Run the multi-cluster spin-up scripts.

## Downloading Ansible Galaxy roles

If this is your first time cloning this repository, go ahead and initialize the requirements for Ansible Galaxy with:

```
ansible-galaxy install -r requirements.yml
```

## Creating an inventory for your virthost

We call the box we run the virtual machines on "the virthost" generally. Let's create an inventory for it.

**NOTE**: You'll need to update the IP address to the proper one for your virthost. You can also change the name from `droctagon2` to any name you wish.

```
export VIRTHOST_IP=192.168.1.55
cat << EOF > ./inventory/virthost.inventory
droctagon2 ansible_host=$VIRTHOST_IP ansible_ssh_user=root

[virthost]
droctagon2
EOF
```

## Setting up the virt-host

You'll first need to run a playbook to setup the virt host. This has the  side-effect of also spinning up some VMs -- which we don't need yet. So you'll do this first, and then we'll use those VMs to test we can access them and then we'll remove those VMs.

```
ansible-playbook -i inventory/virthost.inventory -e 'ssh_proxy_enabled=true' playbooks/virthost-setup.yml
```

This will result in a locally generated inventory with the VMs that were spun up:

```
cat inventory/vms.local.generated
```

Now we can use information from that in order to access those machines -- a key has been created for us too in `/home/{your user name}/.ssh/{virthost name}/id_vm_rsa`

So for example I can SSH to a VM using:

```
ssh -i /home/doug/.ssh/droctagon2/id_vm_rsa -o ProxyCommand="ssh -W %h:%p root@192.168.1.55" centos@192.168.122.68
```

Where:

* `/home/doug/.ssh/droctagon2/id_vm_rsa` is the name of the key at the bottom of the `./inventory/vms.local.generated`
* `192.168.1.55` is the IP address of my virtualization host
* `192.168.122.68` is the IP address of the VM from the top section of the `./inventory/vms.local.generated`

Now you can remove those VMs (and I recommend you do) with:

```
ansible-playbook -i inventory/virthost.inventory playbooks/vm-teardown.yml
```

## OPTION: Download the bootstrap image

Go ahead and place this image on your virtualization host, that is, SSH to the virt host

```
curl http://speedmodeling.org/kube/bootstrapped.qcow2 -o /home/images/bootstrapped.qcow2
```

## Creating the bootstrap image.

You can skip this if you downloaded an existing one.

You can run it for example like so:

```
$ ansible-playbook -i inventory/virthost.inventory \
  -e "@./inventory/examples/image-bootstrap/extravars.yml" \
  playbooks/create-bootstrapped-image.yml
```


## Run the multi-cluster spin up all at once...

These scripts expect your virthost inventory to live @ `./inventory/virthost.inventory`.

It might be convenient to set the number of clusters like so:

```
export CLUSTERS=3
```

"Run it all" with the all.sh script which runs all the individual plays.

```
./contrib/multi-cluster/all.sh $CLUSTERS
```

After you've set it up, you'll find the information to log into the clusters in your inventory directory...

```
cat inventory/multi-cluster/cluster-1.inventory
```

Replace `1` with whatever cluster number. So if you had `CLUSTERS=3` you should have `cluster-1.inventory` through `cluster-3.inventory`

You can then use the IP addresses as listed in these inventories to SSH to each of the hosts. The same SSH key as used earlier is still the key you'll use, and should be listed in each of the inventories.

When this completes, you should now have a number of clusters. Let's take a look at the first cluster. 

```
ssh -i /home/doug/.ssh/droctagon2/id_vm_rsa -o ProxyCommand="ssh -W %h:%p root@192.168.1.55" centos@$(cat inventory/multi-cluster/cluster-1.inventory | grep kube-master-1 | head -n1 | cut -d= -f2)
```

Replace the SSH key with your own, as well as the `root@192.168.1.55` with the IP address of your virthost.

Now, after SSHing to that machine -- you should be able to see:

```
[centos@kube-master-1 ~]$ kubectl get nodes
NAME            STATUS     ROLES     AGE       VERSION
kube-master-1   NotReady   master    1h        v1.11.2
kube-node-2     NotReady   <none>    1h        v1.11.2
kube-node-3     NotReady   <none>    1h        v1.11.2
```

Note that the `NotReady` state is expected, as this cluster is up, however, it is intentionally not ready because the attendees are expected to install the CNI plugins.

You can then tear down those VMs if you please:

```
./contrib/multi-cluster/multi-teardown.sh $CLUSTERS
```


## Giving access via SSH to people

Firstly, you must set the `CLUSTERS` environment variable for this to work. Requires a Perl install on the machine you're running it from.

```
export CLUSTERS=3
./contrib/multi-cluster/tmate.pl
```

This will create 2 tmate sessions for each master machine. (One for a backup in case the user types 'exit', which will ruin that session)

The output will give you a JSON structure, you're looking for the line that looks like:

```
     "link": "https://markdownshare.com/view/ea8571af-8c97-469a-935b-470f33476214",
```

This will be a link to the posted markdown showing the tmate SSH urls.

## Multi-cluster a la carte -- step-by-step if you please.

Run it with the number of clusters you're going to create.

```
./contrib/multi-cluster/extravars-creator.sh $CLUSTERS
```

Then you can run the multi spinup...

```
./contrib/multi-cluster/multi-spinup.sh $CLUSTERS
```

Bring up the kube clusters with a multi init...

```
./contrib/multi-cluster/multi-init.sh $CLUSTERS
```

And tear 'em down with the multi-teardown...

```
./contrib/multi-cluster/multi-teardown.sh $CLUSTERS
```

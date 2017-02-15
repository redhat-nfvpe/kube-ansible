# kube-centos

Install kubernetes 1.5 on a cluster of CentOS VMs.

## Usage

Step 1. Modify `./inventory/virthost.inventory` to setup a virt host (skip to step 2 if you already have an inventory)

```
ansible-playbook -i inventory/virthost.inventory virt-host-setup.yml 
```

Step 2. Modify `./inventory/vms.inventory` Setup kube on all the hosts.

```

```

## About

Initially inspired by 

* [k8s 1.5 on Centos](http://linoxide.com/containers/setup-kubernetes-kubeadm-centos/)
* [kubeadm getting started](https://kubernetes.io/docs/getting-started-guides/kubeadm/)

## On CNI

Run into an issue that looks kind of [like this](https://github.com/kubernetes/kubernetes/issues/36575) so I added `--pod-network-cidr=` but then I got:

```
  FirstSeen LastSeen    Count   From            SubObjectPath   Type        Reason      Message
  --------- --------    -----   ----            -------------   --------    ------      -------
  6m        6m      1   {default-scheduler }            Normal      Scheduled   Successfully assigned nginx-17db8 to kube-minion-2
  6m        6m      3   {kubelet kube-minion-2}         Warning     FailedSync  Error syncing pod, skipping: failed to "SetupNetwork" for "nginx-17db8_default" with SetupNetworkError: "Failed to setup network for pod \"nginx-17db8_default(1a2b64f2-f39b-11e6-a7ae-52540078670a)\" using network plugins \"cni\": cni config unintialized; Skipping pod"
```

My guess is because I'm being stubborn and trying to use Flannel plainly. I think I should try weave as shown in... basically every single example I see.



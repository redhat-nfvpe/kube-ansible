# Let's spin up k8s 1.5 on CentOS!

Alright, so you've seen my blog [post about installing Kubernetes by hand](http://dougbtv.com/nfvpe/2017/02/09/kubernetes-on-centos/) on CentOS, now... Let's make that easier and do that with an Ansible playbook, specifically my [kube-centos-ansible](https://github.com/dougbtv/kube-centos-ansible) playbook. This time we'll have Kubernetes 1.5 running on a cluster of 3 VMs, and we'll use weave as a CNI plugin to handle our pod network. And to make it more fun, we'll even expose some pods to the 'outside world', so we can actually (kinda) do something with them. Ready? Let's go!

## What's inside?

Alright, so here's the parts of this playbook, and it...

1. Configures a machine to use as a virtual machine host (and you can skip this part if you want to run on baremetal, or an inventory of machines created otherwise, say on OpenStack)
2. Installs all the deps necessary on the hosts
3. Runs `kubeadm init` to bootstrap the cluster ([kubeadm docs](https://kubernetes.io/docs/getting-started-guides/kubeadm/))
4. Installs a CNI plugin for pod networking (for now, it's weave)
5. Joins the hosts to a cluster.

## What do you need?

Along with the below you need a client machine from which to run your ansible playbooks. It can be the same host as one of the below if you want, but, you'll need to install ansible & git on that machine whatever one it may be. Once you've got that machine, go ahead and clone this repo.

```
$ git clone https://github.com/dougbtv/kube-centos-ansible.git
$ cd kube-centos-ansible
```

In a choose your own adventure style, you can either choose from the below. 

A. Pick a single host and use it to host your virtual machines. We'll call this machine either the "virt host" or "virtual machine host" throughout here. This assumes that you have a CentOS 7 machine (that's generally up to the latest packages). You'll need an SSH key into this machine as root (or modify the inventory later on if you're sshing in as another user, who'll need sudo access). Go to section "A: Virtual machine host and VM spin-up"

B. Create your own inventory. Spin up some CentOS machines, either baremetal or virtual machines, and make note of the IP addresses. Skip on over to section "B: Define the inventory of kubernetes nodes"

## A: Virtual machine host and VM spin-up

Ok, let's first modify the inventory. Get the IP address of your virt-host, and we'll modify the `./inventory/virthost.inventory` and enter in the IP address there (or hostname, should you have some fancy-pants DNS setup).

The line you're looking to modify is right up at the top and looks like:

```
kubehost ansible_host=192.168.1.119 ansible_ssh_user=root
```

Now we can run this playbook, it should be fairly straight forward, it installs the virtualization deps for KVM/libvirt and then spins up the VMs for you and reports their IP addresses.

You run the playbook like so:

```
$ ansible-playbook -i inventory/virthost.inventory virt-host-setup.yml 
```

When it completes you'll get some output that looks about like this, yours will more-than-likely have different IP addresses, so make sure to note those:

```
TASK [vm-spinup : Here are the IPs of the VMs] *********************************
ok: [kubehost] => {
    "msg": {
        "kube-master": "192.168.122.11", 
        "kube-minion-1": "192.168.122.176", 
        "kube-minion-2": "192.168.122.84"
    }
}
```

You can also find them in the `/etc/hosts` on the virt-host for convenience, like so:

```
$ cat /etc/hosts | grep -i kube
192.168.122.11 kube-master
192.168.122.84 kube-minion-2
192.168.122.176 kube-minion-1
```

This playbook also creates an ssh key pair that's used to access these machines. This key lives in root's home @ `/root/.ssh/`. The machines that are spun up are CentOS Generic cloud images and you'll need to ssh as the `centos` user.

So you can ssh to the master from this virt host like so:

```
ssh -i .ssh/id_vm_rsa centos@kube-master
```

Notes that the default way the playbook runs is to create 3 nodes. You can get fancy if you want and use more nodes by modifying the list of nodes in the `./vars/all.yml` should you wish, and modifying the inventory appropriately in the next section.

Continue onto section B below with the IP addresses you've seen come up.

## B: Define the inventory of kubernetes nodes

Alright, now you're going to need to modify the `./inventory/vms.inventory` file.

First modify the top most lines, usually 3 if you're doing the default 3 as recommended earlier.

```
$ head -n3 ./inventory/vms.inventory 
kube-master ansible_host=192.168.122.213
kube-minion-1 ansible_host=192.168.122.185
kube-minion-2 ansible_host=192.168.122.125
```

Modify these to suit your inventory.

Towards the end of the file, there's some host vars setup, you'll also want to modify these. If you used the virt-host method, you'll want to change `192.168.1.119` in the `ansible_ssh_common_args` -- unless you're running ansible from there in which case, comment this. Also SCP the `/root/.ssh/id_vm_rsa` to your client machine and put that in the `ansible_ssh_private_key_file`.

If you brought your own inventory, typically you'd probably comment out both the last two lines: `ansible_ssh_common_args` and `ansible_ssh_private_key_file`

```
$ tail -n6 ./inventory/vms.inventory 
[all_vms:vars]
ansible_ssh_user=centos
ansible_become=true
ansible_become_user=root
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p root@192.168.1.119"'
ansible_ssh_private_key_file=/home/doug/.ssh/id_testvms
```

## Now we can install k8s

Alright, now that the `./inventory/vms.inventory` file is setup, we can get along moving to install k8s! Honestly, the hardest stuff is complete at this point. Let's run it.

```
$ ansible-playbook -i inventory/vms.inventory kube-install.yml
```

(Be prepared to accept the host keys by typing 'yes' when prompted if you haven't ssh'd to these machines before. And beforewarned that you don't type "yes" too many times, cause you might put in the command `yes` which will just fill your terminal with a ton of 'y' characters!).

Alright, you're good to go! SSH to the master and let's see that everything looks good.

On the master, let's look at the nodes...

```
[root@virthost ~]# ssh -i .ssh/id_vm_rsa centos@kube-master
[centos@kube-master ~]$ kubectl get nodes
NAME            STATUS         AGE
kube-master     Ready,master   4m
kube-minion-1   Ready          2m
kube-minion-2   Ready          2m
```

There's a number of pods running to support the pod networking, you can check those out with:

```
# All the pods
[centos@kube-master ~]$ kubectl get pods --all-namespaces
[... lots of pods ...]
# Specifically the kube-system pods
[centos@kube-master ~]$ kubectl get pods --namespace=kube-system
```

And we wanted k8s 1.5 right? Let's check that out.

```
[centos@kube-master ~]$ kubectl version | grep -i server
Server Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.3", GitCommit:"029c3a408176b55c30846f0faedf56aae5992e9b", GitTreeState:"clean", BuildDate:"2017-02-15T06:34:56Z", GoVersion:"go1.7.4", Compiler:"gc", Platform:"linux/amd64"}
```

Alright, that looks good, so let's move on and do something interesting with it...

## Let's run some pods!

Ok, we'll do the same thing as the previous blog article and we'll run some nginx pods. 

Let's create an `nginx_pod.yaml` like so:

```
[centos@kube-master ~]$ cat nginx_pod.yaml 
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

Then we can run it...

```
[centos@kube-master ~]$ kubectl create -f nginx_pod.yaml 
```

And we can see the two instances come up...

```
[centos@kube-master ~]$ kubectl get pods
NAME          READY     STATUS    RESTARTS   AGE
nginx-34vhj   1/1       Running   0          1m
nginx-tkh4h   1/1       Running   0          1m
```

And we can get some details, should we want to...

```
[centos@kube-master ~]$ kubectl describe pod nginx-34vhj
```

And this is no fun if we can't put these pods on the network, so let's expose a pod.

First off, get the IP address of the master.

```
[centos@kube-master ~]$ master_ip=$(ifconfig | grep 192 | awk '{print $2}')
[centos@kube-master ~]$ echo $master_ip
192.168.122.11
```

And let's use that as an external address... And expose a service.

```
[centos@kube-master ~]$ kubectl expose rc nginx --port=8999 --target-port=80 --external-ip $master_ip
service "nginx" exposed
```

And we can see it in our list of services...

```
[centos@kube-master ~]$ kubectl get svc
NAME         CLUSTER-IP     EXTERNAL-IP      PORT(S)    AGE
kubernetes   10.96.0.1      <none>           443/TCP    20m
nginx        10.107.64.92   192.168.122.11   8999/TCP   4s
```

And we can describe that service should we want more details...

```
[centos@kube-master ~]$ kubectl describe service nginx
```

Now, we can access the load balanced nginx pods from the virt-host (or your client machine should you have brought your own inventory)

```
[root@virthost ~]# curl -s 192.168.122.11:8999 | grep -i thank
<p><em>Thank you for using nginx.</em></p>
```

Voila! There we go, we have exposed nginx pods running on port 8999, an external IP on the master node, with Weave for the pod network using CNI.



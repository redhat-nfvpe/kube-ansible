# Let's spin up k8s 1.5 on CentOS!

Alright, so you've seen my blog [post about installing Kubernetes by hand](http://dougbtv.com/nfvpe/2017/02/09/kubernetes-on-centos/) on CentOS, now... Let's make that easier and do that with an Ansible playbook. This time we'll have Kubernetes 1.5 running on a cluster of 3 VMs, and we'll use weave as a CNI plugin to handle our pod network. And to make it more fun, we'll even expose some pods to the 'outside world', so we can actually (kinda) do something with them. Ready? Let's go!

## What's inside?

Alright, so here's the parts of this playbook, and it...

1. Configures a machine to use as a virtual machine host (and you can skip this part if you want to run on baremetal, or an inventory of machines created otherwise, say on OpenStack)
2. Installs all the deps necessary on the hosts
3. Runs `kubeadm init` to bootstrap the cluster
4. Installs a CNI plugin for pod networking (for now, it's weave)
5. Joins the hosts to a cluster.

## So let's get kickin'!

Alright, first thing's first, your client machine is going to need git and ansible. This could be the same machine as the virtual machine host if you'd like.



# RBAC


[Here's the bible](https://kubernetes.io/docs/admin/authorization/rbac/#service-account-permissions)

Help from [@liggitt](https://github.com/liggitt) (Jordan Liggitt)

```
liggitt [1:08 PM] 
if you’re on 1.6 with RBAC, you’ll want to keep https://kubernetes.io/docs/admin/authorization/rbac/#service-account-permissions  close at hand (edited)

[1:10]  
most things don’t define their own roles (which is fine, the default `view`, `edit`, `admin`, `cluster-admin` roles cover a ton of use cases), but very few apps explain the API permissions they require (some need none, some need read-only access, some assume they are root, etc)

dougbtv [1:12 PM] 
awesome, appreciate the pointer, insightful on the roles. looking forward to getting my feet wet with RBAC, too

liggitt [1:12 PM] 
handing out permissions to the service accounts you’re running apps with is part of running an app on your cluster. if you don’t care what has access, you can grant really broad permissions and be done with it. if you want to know what is doing what, you can get more granular. (edited)
```

## Flannel

[flannel]https://github.com/coreos/flannel/blob/master/Documentation/kube-flannel-rbac.yml

## Now having trouble with flannel having network connections outside...

[wan connectivity doesn't work](http://pasteall.org/338143)
[IP tables forward didn't work](http://pasteall.org/338157)

Some ideas from slack:

```
foxie [9:04 AM] 
@dougbtv when has it started? Have you by any chance updated to docker 1.13.x or 1.17.x?

dougbtv [9:11 AM] 
@foxie  I'm on `Docker version 17.03.1-ce, build c6d412e`

[9:11]  
good chance that when I was using kube 1.5 I was using 1.12.x

[9:14]  
(I might try to reinstall the cluster with 1.12, that's a good possibility to eliminate! appreciate the brain cycles)

foxie [9:16 AM] 
you may want to try

[9:16]  
iptables -P FORWARD ACCEPT

[9:16]  
they changed that with 1.13

dougbtv [9:21 AM] 
awesome idea -- didn't exactly work for me, but, I think you're onto something, for some reason those iptables rules look like I'm missing something and I can't quite put my finger on it. fwiw, here's the results of giving that a try: http://pasteall.org/338157
```


Tried inserting the rule at the top for fun...

## Roll-back to docker 1.12

Let's see what we can do... 

[Following this issue-comment](https://github.com/kubernetes/kubeadm/issues/212#issuecomment-291413672)

We need to specifically do this one:

> (/etc/systemd/system/kubelet.service.d/10-kubeadm.conf) add "--cgroup-driver=systemd" at the end of the last line.
=> This is because Docker uses systemd for cgroup-driver while kubelet uses cgroupfs for cgroup-driver.


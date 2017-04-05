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
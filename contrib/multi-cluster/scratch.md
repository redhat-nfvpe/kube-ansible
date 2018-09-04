# kubernetes patch process

Unfortunately this results in a conflicting `pkg/kubectl/genericclioptions/resource/helper_test.go`

```
git clone https://github.com/dashpole/kubernetes.git dashpole.kubernetes
cd dashpole.kubernetes/
git remote add upstream https://github.com/kubernetes/kubernetes.git
git fetch upstream
git checkout release-1.11
git pull
git checkout device_id
git checkout -b rebase_deviceid
git rebase release-1.11 
```

This results in a lot of errors.

```
git diff HEAD~6 > /tmp/kube.patch
wc -l /tmp/kube.patch 
git checkout release-1.11 
git apply /tmp/kube.patch
```

Making with a custom version...

> @dougbtv looking at code in the scripts that build the version number, looks like you can set `KUBE_GIT_VERSION_FILE` to a file and the file can have the format and you can set it to anything you wish. (Though to be honest i haven’t tried quick-release with it)

```
[centos@kube-dev kubernetes]$ cat DOUG.VERSION.FILE 
KUBE_GIT_COMMIT='9ff717ee9c87d5b3248a3d28b8893e21028ea42d'
KUBE_GIT_TREE_STATE='clean'
KUBE_GIT_VERSION='v1.11.2-beta.0.2333+9ff717ee9c87d5'
KUBE_GIT_MAJOR='1'
KUBE_GIT_MINOR='11+'
```

Then build it...

```
$ export KUBE_GIT_VERSION_FILE=/home/centos/kubernetes/DOUG.VERSION.FILE 
$ make quick-release
```

```
KUBE_GIT_VERSION_FILE=/home/centos/kubernetes/DOUG.VERSION.FILE KUBE_FASTBUILD=true make quick-release
```

Building the image...

```
KUBE_DOCKER_IMAGE_TAG=vX.Y.Z KUBE_DOCKER_REGISTRY=k8s.gcr.io KUBE_FASTBUILD=true make quick-release
```


---

# virtdp

make the master scheduleable.

```
kubectl taint node kube-master-1 node-role.kubernetes.io/master:NoSchedule-
kubectl label nodes kube-master-1 dedicated=master
```

```
[centos@kube-master-1 virt-network-device-plugin]$ cat deployments/pod-virtdp.yaml 
kind: Pod
apiVersion: v1
metadata:
        name: virt-device-plugin
spec:
  nodeSelector:
    dedicated: master
  tolerations:
    - key: node-role.kubernetes.io/master
      operator: Equal
      value: master
      effect: NoSchedule
  containers:
  - name: virt-device-plugin
    image: virt-device-plugin
    imagePullPolicy: IfNotPresent
    command: [ "/usr/bin/virtdp", "-logtostderr", "-v", "10" ]
    # command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 300000; done;" ]
    #securityContext:
        #privileged: true
    volumeMounts:
    - mountPath: /var/lib/kubelet/device-plugins/
      name: devicesock
      readOnly: false
    - mountPath: /sys/class/net
      name: net
      readOnly: true
  volumes:
  - name: devicesock
    hostPath:
     # directory location on host
     path: /var/lib/kubelet/device-plugins/
  - name: net
    hostPath:
      path: /sys/class/net
  hostNetwork: true
  hostPID: true
```

```
<zshi> dougbtv, I think I found the cause of why with kubeadm it was failing:  could you please help to check if 1) in api-servver yaml file, --enable-admission-plugins=NodeRestriction is set; 2) in kubelet config.yaml (/var/lib/kubelet/config.yaml)  ComputeDevice feature-gates is set
<dougbtv> zshi, takinga  look!
<dougbtv> zshi, 1. where's the api server yaml? 
<zshi> dougbtv, /etc/kubernetes/manifests/kube-apiserver.yaml
<dougbtv> and 2. I do not see the ComputeDevice in /var/lib/kubelet/config.yaml -- do you have an example for that?
<dougbtv> ok, sweet in that apiserver I have `--feature-gates=ComputeDevice=true`
<zshi> for 2 : http://pasteall.org/1159284
<dougbtv> ty! looking
<zshi> for 1, check if this exist : --enable-admission-plugins=NodeRestriction 
<zshi> if yes, then remove NodeRestriction
<dougbtv> ahhh yeah looking for wrong thing in there, looking, thanks
<dougbtv> zshi, it's in there :)
<dougbtv> --enable-admission-plugins=NodeRestriction
<zshi> I'm using "LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,StorageObjectInUseProtection" for --enable-admission-plugins
<zshi> although it doesn't really need those admissions, the point here is to remove NodeRestriction
<dougbtv> cool, alright, restarting kubelet and api server, one sec :)
<zshi> here is what I got when creating the pod, the computeDevice is in api-server : http://pasteall.org/1159329
```

```
[centos@kube-master-1 ~]$ cat /etc/cni/net.d/70-multus.conf
{
  "name": "multus-cni-network",
  "type": "multus",
  "delegates": [
    {
      "type": "flannel",
      "name": "flannel.1",
      "delegate": {
        "isDefaultGateway": true,
        "hairpinMode": true
      }
    }
  ],
  "kubeconfig": "/etc/cni/net.d/multus.d/multus.kubeconfig",
  "LogFile": "/var/log/multus.log",
  "LogLevel": "debug"
}
```


```
[centos@kube-master-1 ~]$ cat virt-dp.yml 
kind: Pod
apiVersion: v1
metadata:
        name: virt-device-plugin
spec:
  nodeSelector:
    dedicated: master
  tolerations:
    - key: node-role.kubernetes.io/master
      operator: Equal
      value: master
      effect: NoSchedule
  containers:
  - name: virt-device-plugin
    image: virt-device-plugin
    imagePullPolicy: IfNotPresent
    command: [ "/usr/bin/virtdp", "-logtostderr", "-v", "10" ]
    # command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 300000; done;" ]
    #securityContext:
        #privileged: true
    volumeMounts:
    - mountPath: /var/lib/kubelet/device-plugins/
      name: devicesock
      readOnly: false
    - mountPath: /sys/class/net
      name: net
      readOnly: true
  volumes:
  - name: devicesock
    hostPath:
     # directory location on host
     path: /var/lib/kubelet/device-plugins/
  - name: net
    hostPath:
      path: /sys/class/net
  hostNetwork: true
  hostPID: true
```

```
[centos@kube-master-1 ~]$ cat modified.virt-crd.yaml 
apiVersion: "k8s.cni.cncf.io/v1"
kind: NetworkAttachmentDefinition
metadata:
  name: virt-net1
  annotations:
    k8s.v1.cni.cncf.io/resourceName: kernel.org/virt
spec:
  config: '{
    "type": "ehost-device",
        "name": "virt-network",
        "cniVersion": "0.3.0",
        "deviceID": "0000:00:09.0",
    "ipam": {
        "type": "host-local",
        "subnet": "10.56.217.0/24",
        "routes": [{
            "dst": "0.0.0.0/0"
        }],
        "gateway": "10.56.217.1"
    }
}'
```


```
[centos@kube-master-1 ~]$ cat pod-tc1.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: testpod1
  labels:
    env: test
  annotations:
    k8s.v1.cni.cncf.io/networks: virt-net1
spec:
  containers:
  - name: appcntr1
    image: dougbtv/centos-network
    imagePullPolicy: IfNotPresent
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 300000; done;" ]
    resources:
      requests:
        memory: "128Mi"
        kernel.org/virt: '1'
      limits:
        memory: "128Mi"
        kernel.org/virt: '1'
```

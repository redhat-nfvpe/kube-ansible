## Showing some pertinent details about our nginx pods...

[root@kube-master centos]# kubectl get pods | tail -n +2 | awk '{print $1}' | xargs -i kubectl describe pod {} | grep -Pi "(^Node|^Name[^s]|^IP)"

## On CNI

Run into an issue that looks kind of [like this](https://github.com/kubernetes/kubernetes/issues/36575) so I added `--pod-network-cidr=` but then I got:

```
  FirstSeen LastSeen    Count   From            SubObjectPath   Type        Reason      Message
  --------- --------    -----   ----            -------------   --------    ------      -------
  6m        6m      1   {default-scheduler }            Normal      Scheduled   Successfully assigned nginx-17db8 to kube-node-2
  6m        6m      3   {kubelet kube-node-2}         Warning     FailedSync  Error syncing pod, skipping: failed to "SetupNetwork" for "nginx-17db8_default" with SetupNetworkError: "Failed to setup network for pod \"nginx-17db8_default(1a2b64f2-f39b-11e6-a7ae-52540078670a)\" using network plugins \"cni\": cni config unintialized; Skipping pod"
```

My guess is because I'm being stubborn and trying to use Flannel plainly. I think I should try weave as shown in... basically every single example I see.


----

## History from kube master on successful run

```
[root@kube-master centos]# history
    1  kubectl get nodes
    2  yum install -y nano mlocate
    3  nano nginx_pod.yaml
    4  kubectl create -f nginx_pod.yaml 
    5  kubectl get pods
    6  kubectl get pods
    7  kubectl describe pod nginx-507br
    8  updatedb
    9  locate cni
   10  cd /etc/cni/net.d/
   11  ls
   12  cat 10-weave.conf 
   13  cd /var/log/
   14  ls -lathr
   15  cat podnetwork-apply.log
   16  kubectl get pods
   17  kubectl describe pod nginx-507br
   18  kubectl status
   19  kubectl get status
   20  kubectl get pods
   21  kubectl apply -f https://git.io/weave-kube
   22  kubectl get pods
   23  cd /etc/
   24  ls -lathr
   25  cat kubeadm.init.txt 
   26  kubectl get namespaces
   27  kubectl get pods --namespace=kube-system
   28  kubectl get pods --namespace=default
   29  kubectl describe pod nginx-507br
   30  kubectl get pods --namespace=kube-system
   31  kubectl get pods 
   32  kubectl get pods 
   33  kubectl describe pod nginx-507br
   34  ifconfig
   35  curl 10.38.0.1
   36  route -n
   37  kubectl describe pod nginx-507br
   38  kubectl get pods
   39  kubectl describe pod nginx-507br
   40  kubectl describe pod nginx-wwnl8
   41  cd ~
   42  ls
   43  updatedb
   44  locate nginx_pod
   45  cd /home/centos/
   46  ls
   47  cat nginx_pod.yaml 
   48  kubectl expose rc nginx --port=8999 --target-port=8000
   49  kubectl get svc
   50  curl 10.111.204.122:8999
   51  curl 10.111.204.122:8999
   52  route -n
   53  iptables -L
   54  systemctl status firewalld
   55  iptables -A INPUT -p tcp --dport 8999 -j ACCEPT
   56  iptables -L
   57  iptables -n -L
   58  curl 10.111.204.122:8999
   59  route -n
   60  ifconfig
   61  kubectl get svc
   62  curl -k https://10.96.0.1
   63  iptables -n -L
   64  curl -v 10.111.204.122:8999
   65  ping 10.111.204.122
   66  kubectl get svc
   67  kubectl get pods
   68  kubectl describe pod nginx-wwnl8
   69  kubectl describe pod nginx-507br
   70  curl 10.38.0.1
   71  curl 10.32.0.2
   72  kubectl describe pod nginx-507br | grep -Pi "(^Node)"
   73  kubectl describe pod nginx-507br | grep -Pi "(^Node|^IP)"
   74  kubectl get pods
   75  kubectl get pods | tail -n +1
   76  kubectl get pods | tail -n +2
   77  kubectl get pods | tail -n +2 | awk '{print $1}'
   78  kubectl get pods | tail -n +2 | awk '{print $1}' | xargs -i kubectl describe pod {} | grep -Pi "(^Node|^IP)"
   79  kubectl get pods | tail -n +2 | awk '{print $1}' | xargs -i kubectl describe pod {} | grep -Pi "(^Node|^Name[^s]|^IP)"
   80  kubectl get svc
   81  curl 10.111.204.122
   82  curl 10.111.204.122:8999
   83  kubectl describe svc nginx
   84  kubectl delete svc nginx
   85  history | grep -i svc
   86  history | grep -i service
   87  history | grep -i expose
   88  kubectl expose rc nginx --port=8999 --target-port=80
   89  curl 10.111.204.122:8999
   90  kubectl get svc
   91  curl 10.96.194.77:8999
   92  curl 10.96.194.77:8999
   93  iptables -L INPUT
   94  iptables -L INPUT --linenumbers
   95  iptables -D 
   96  iptables -n -L INPUT --linenumbers
   97  iptables -n -L INPUT --line-numbers
   98  iptables -D 7 INPUT
   99  iptables -D INPUT 7
  100  curl 10.96.194.77:8999
  101  kubectl get svc
  102  history | grep expose
  103  ifconfig | grep 192
  104  kubectl get svc
  105  kubectl delete svc nginx
  106  kubectl expose rc nginx --port=8999 --target-port=80 --external-ip 192.168.122.213
  107  kubectl get svc
  108  curl 192.168.122.213:8999
  109  history
```

```
[root@kube-master centos]# cat nginx_pod.yaml 
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
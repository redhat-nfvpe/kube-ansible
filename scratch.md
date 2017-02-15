## Showing some pertinent details about our nginx pods...

[root@kube-master centos]# kubectl get pods | tail -n +2 | awk '{print $1}' | xargs -i kubectl describe pod {} | grep -Pi "(^Node|^Name[^s]|^IP)"


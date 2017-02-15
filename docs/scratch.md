## Showing some pertinent details about our nginx pods...

[root@kube-master centos]# kubectl get pods | tail -n +2 | awk '{print $1}' | xargs -i kubectl describe pod {} | grep -Pi "(^Node|^Name[^s]|^IP)"

## On CNI

Run into an issue that looks kind of [like this](https://github.com/kubernetes/kubernetes/issues/36575) so I added `--pod-network-cidr=` but then I got:

```
  FirstSeen LastSeen    Count   From            SubObjectPath   Type        Reason      Message
  --------- --------    -----   ----            -------------   --------    ------      -------
  6m        6m      1   {default-scheduler }            Normal      Scheduled   Successfully assigned nginx-17db8 to kube-minion-2
  6m        6m      3   {kubelet kube-minion-2}         Warning     FailedSync  Error syncing pod, skipping: failed to "SetupNetwork" for "nginx-17db8_default" with SetupNetworkError: "Failed to setup network for pod \"nginx-17db8_default(1a2b64f2-f39b-11e6-a7ae-52540078670a)\" using network plugins \"cni\": cni config unintialized; Skipping pod"
```

My guess is because I'm being stubborn and trying to use Flannel plainly. I think I should try weave as shown in... basically every single example I see.

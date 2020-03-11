This document contains detail about the possible issue that you might encounter while deploying Kubernetes cluster using kube-ansible.

#### Python 2 binding related error

**Issue:** You might encounter the following error if you specify `ansible_python_interpreter` in virthost.inventory file.
```
The Python 2 bindings for rpm are needed for this module. If you require Python 3 support use the `dnf` Ansible module instead.. The Python 2 yum module is needed for this module. If you require Python 3 support use the `dnf` Ansible module instead.

```
**Fix:** Remove the `ansible_python_interpreter` from virthost.inventory, it will resort for python2.7 interpreter.

### OVN DB (NB & SB) cluster doesn't come-up successfully and result in failed ovn-kubernetes deployment.
K8S cluster hosted on VMs (libvirt), DNS of the hostname is resolved through the libvirt dnsmasq.
If VM ends up with the stale DNS entry for the hostname, OVN NB db cluster will pickup the wrong ip
address for the hostname and it will try to bind to that address, which will fail and result in broken RAFT cluster for
NB and SB databases.
To verify that you possibly are hitting this issue, you can check the ovndb-nb logs and look for
```
2020-03-06T23:31:34.223365946+00:00 stdout F Creating cluster database /etc/ovn/ovnnb_db.db.
2020-03-06T23:31:34.264442237+00:00 stderr F 2020-03-06T23:31:34Z|00001|vlog|INFO|opened log file /var/log/ovn/ovsdb-server-nb.log
2020-03-06T23:31:34.272737799+00:00 stderr F 2020-03-06T23:31:34Z|00002|raft|INFO|term 1: 678573 ms timeout expired, starting election
2020-03-06T23:31:34.272737799+00:00 stderr F 2020-03-06T23:31:34Z|00003|raft|INFO|term 1: elected leader by 1+ of 1 servers
2020-03-06T23:31:34.280252334+00:00 stderr F 2020-03-06T23:31:34Z|00004|ovsdb_server|INFO|ovsdb-server (Open vSwitch) 2.12.0
2020-03-06T23:31:34.280666734+00:00 stderr F 2020-03-06T23:31:34Z|00005|socket_util|ERR|6643:192.168.122.41: bind: Cannot assign requested address
2020-03-06T23:31:34.280749768+00:00 stderr F 2020-03-06T23:31:34Z|00006|raft|WARN|ptcp:6643:192.168.122.41: listen failed (Cannot assign requested address)
```
and if you will check the ip address of the host machine, it will be different that 192.168.122.41 as shown
in the example logs above. OVN-Kubernetes picks the IP address of the host using `getent ahostsv4 <hostname>`, so if the host shows different IP
address from `getent ahostsv4 <hostname>` & `ifconfig` on that host, it means your DNS cache is stale and needs refresh.

**Workaround** Make sure that the dnsmasq service is in correct state on your physical machine where libvirt is running.
Fire `pkill -HUP dnsmasq` on the physical machine, it will result in `dnsmasq` loading the fresh configuration and
now `getent ahostsv4 <hostname>` should in VM should show the same ip address as `ifconfig`. Once DNS caches are refresh,
 you can trigger the ansible-playbook that installs the k8s deployment.

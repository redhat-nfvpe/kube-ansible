This document contains detail about the possible issue that you might encounter while deploying Kubernetes cluster using kube-ansible.

#### Python 2 binding related error

**Issue:** You might encounter the following error if you specify `ansible_python_interpreter` in virthost.inventory file.
```
The Python 2 bindings for rpm are needed for this module. If you require Python 3 support use the `dnf` Ansible module instead.. The Python 2 yum module is needed for this module. If you require Python 3 support use the `dnf` Ansible module instead.

```
**Fix:** Remove the `ansible_python_interpreter` from virthost.inventory, it will resort for python2.7 interpreter.

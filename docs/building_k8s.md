# Building Kubernetes Releases

You can instantiate a virtual machine with kube-ansible in order to
build a Kubernetes release from the upstream Kubernetes git repository. To do
this, you create a heavy (on resources) virtual machine, install the
dependencies, and then run `make bazel-release` using
[Planter](https://github.com/kubernetes/test-infra/tree/master/planter).

## Instantiating a Virtual Machine

Assuming you're familiar with kube-ansible, getting the virtual machine
up and running for a build is relatively straight forward. You add a new
builder VM to your `group_vars/all.yml` file under the `virtual_machines` list.

An example `virtual_machines` list:

```
virtual_machines:
  - name: kube-master
    node_type: master
  - name: kube-node-1
    node_type: nodes
  - name: kube-node-2
    node_type: nodes
  - name: kube-node-3
    node_type: nodes
  - name: builder
    node_type: builder
    system_ram_mb: 24576

```

With our new `builder` machine added to the list, we also need to define some
additional values for the build machine, since it requires quite a few
resources. We have provided the recommended values in the
`group_vars/builder.yml`, so unless you have a need to tune these values,
you're done :) (These values will only be applied to the builder virtual
machine.)

With our configuration done, let's spin up the environment with
`virthost-setup.yml`.

```
ansible-playbook -i inventory/virthost/ virthost-setup.yml
```

When your deployment is done, you'll have the virtual machines for both your
Kubernetes environment, and your build environment.

## Building a Kubernetes Release

To build a Kubernetes release with [Bazel](https://bazel.build/), then we need
to execute the `builder.yml` playbook. We consume roles from
[auto-kube-dev](https://github.com/redhat-nfvpe/auto-kube-dev) to build a
Kubernetes release.

(You can also independently create a build environment with
[auto-kube-dev](https://github.com/redhat-nfvpe/auto-kube-dev). We're simply
consuming the same functionality, and then wrapping it with some additional
automation to make the building even easier.)

Before we run `builder.yml`, we need to install role dependencies. We can do
this with `ansible-galaxy` and feeding in the `requirements.yml` file.

```
ansible-galaxy install -r requirements.yml
```

With our dependencies installed, we can now build a Kubernetes release with
Bazel.

```
ansible-playbook -i inventory/vms.local.generated builder.yml
```

During the run, dependencies will be installed on the `builder` virtual
machine, Kubernetes repositories will be cloned, Docker setup, and Planter
executed to build the release.

The resulting release binaries will be on the builder virtual machine in
`/home/centos/src/go/src/k8s.io/kubernetes/bazel-bin/build/`.

## Copying Artifacts to Kubernetes Nodes

When you run the `builder.yml`, at the end of the build, the artifacts will be
copied over to your Kubernetes nodes (assuming you're consuming the
automatically built inventory file `vms.local.generated`, otherwise you need to
specify your own inventory file that contains the `master` and `nodes` groups
of your Kubernetes nodes).

Artifacts are copied onto the Kubernetes nodes and placed in the
`/opt/k8s/artifacts/` directory.

> **TIP**
>
> If you need to resync artifacts over to the virtual machines (for example, if
> you tore down your Kubernetes cluster, reinstantiated, but didn't destroy the
> builder VM with the artifacts) you can avoid rebuilding the entire set of
> artifacts and synchronize them back over using the `sync_artifacts` Ansible
> tag.
>
> `ansible-playbook -i inventory/vms.local.generated --tags sync_artifacts builder.yml`

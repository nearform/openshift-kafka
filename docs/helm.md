# Kubernetes Helm

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources. Think of it like apt/yum/homebrew for Kubernetes. You can find more info at the [repo](https://github.com/kubernetes/helm).

## Install

Openshift Origin comes with RBAC enabled. It is needed to configure policy and role properly otherwise the `tiller` won't have any privileges to create resources in the cluster.

The following instructions will install the `tiller` in the `kube-system` namespace. This is a namespace where only admin can have privileges to access. If we want to give to our username access to the `kube-system` namespace we need to connect to the master via the bastion host and run from it:

```bash
oadm policy add-cluster-role-to-user cluster-admin <username>
```

The `username` now has the `cluster-admin` role and can execute any operations against any namespaces in the cluster.

Connect to [command-line](https://openshift-master.os.nearform.net/console/command-line) and copy to the clipboard the command:

```bash
oc login https://openshift-master.os.nearform.net --token=<token>
```

Once executed in the local machine this will login the user to the cluster and it will be possible to execute admin operations via `oc` cli against the cluster.

Create the `serviceaccount` under the namespace `kube-system`:

```bash
oc create serviceaccount tiller -n kube-system
```

From the master instance run:

```bash
oadm policy add-cluster-role-to-user cluster-admin -z tiller -n kube-system
```

Finally run locally:

```bash
helm init --service-account tiller
```

Doing so, the `tiller` will be installed in the `kube-system` namespace and it will have privileges to run in all the namespaces in the entire cluster. Notice that `helm` must be installed locally before running the above command. Refer to the official documentation.

## Note

- The `tiller` has been installed in the `kube-system` and it has `cluster-admin` privileges. In other word it can execute every actions against every resources across the entire cluster. Running it, it could be potentially dangerous because it could affect accidentaly the operativity of the resources.
- One other approach to the problem could be to install the `tiller` and the namespace where as user we have access and then give to the `tiller` the `admin` role. In this way, it can create/read/update/delete resources only in that namespace.

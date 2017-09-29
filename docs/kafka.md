# Apache Kafka

Install an Apache Kafka cluster via Helm chart. These instructions require that Helm is installed in the Openshift cluster.

## Install

Create a new project in the cluster:

```bash
oc new-project kafka --display-name="Apache Kakfa" --description="Apache Kafka cluster using Stateful Sets and Zookeper"
```

From the master run:

```bash
oc edit scc anyuid
```

and append to the file the following entries:

```bash
users:
  - system:serviceaccount:default:ci
  - system:serviceaccount:ci:default
  - system:serviceaccount:kafka:default
```

This is needed because the Kafka chart that we use define the `uid` and `guid` equals to `1000`. Openshift runs in a security context which doesn't allow to execute containers with root uid and in general a low uid.

Run locally:

```bash
helm install --name kafka --namespace kafka --version 0.3.0 charts/kafka
```

This will spin up an Apache Kafka cluster with Zookeeper ensembles running under the namespace `kafka`.

## Notes

- It is required that the app nodes are at least 3 and are distributed uniformely across the Availability Zones. If this condition is not met then such an error could appear:

```js
No nodes are available that match all of the following predicates:: MatchInterPodAffinity (1), MatchNodeSelector (3), NoVolumeZoneConflict (4)
```

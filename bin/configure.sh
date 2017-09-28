#!/bin/bash -xe

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

NAMESPACE=kube-system

echo "Configure tiller Service Account"
oc create serviceaccount tiller -n $NAMESPACE
oc adm policy add-cluster-role-to-user cluster-admin -z tiller -n $NAMESPACE

echo "Install Helm"
helm init --service-account=tiller --tiller-namespace $NAMESPACE
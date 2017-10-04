#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o xtrace

HELM_DIR=./charts
HELM_VALUES=./values
NAMESPACE=kafka

if [[ $BASH_VERSION =~ ^3$ ]]; then
    echo "You must execute the script with bash v4.x"
    exit 1
fi

# Declare associative array
declare -A releases
releases=(
    [kafka]='0.3.0'
)

# Create a new project
oc new-project "$NAMESPACE" --display-name="Apache Kakfa" --description="Apache Kafka cluster using Stateful Sets and Zookeper" || true

# Install Helm charts
for name in "${!releases[@]}"; do
    helm install --name "$name" --namespace "$NAMESPACE" --version "${releases[$name]}" -f "$HELM_VALUES"/"$name".yaml "$HELM_DIR"/"$name"
done

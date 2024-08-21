#!/bin/bash

# Script to create and delete a Kind cluster

CLUSTER_NAME="test-cluster"

create_cluster() {
  kind create cluster --name "${CLUSTER_NAME}" --config kind-config.yaml
  kind get kubeconfig --name "${CLUSTER_NAME}" > ./kubeconfig_example
}

delete_cluster() {
  kind delete cluster --name "${CLUSTER_NAME}"
}

case "$1" in
  "create")
    create_cluster
    ;;
  "delete")
    delete_cluster
    ;;
  *)
    echo "Usage: $0 {create|delete}"
    exit 1
    ;;
esac

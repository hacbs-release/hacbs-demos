#!/usr/bin/env bash
set -eux

COSIGN_SECRET_NAME="cosign-public-key"
NAMESPACE="managed-rbean"
QUAY_ROBOT_ACCOUNT="hacbs-release-tests+m5_robot_account"
QUAY_SECRET_NAME="hacbs-release-tests-token"
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

tempDir=$(mktemp -d /tmp/m7.XXX)
trap 'rm -rf "$tempDir"' EXIT

create_resources() {
  kubectl apply -k "$SCRIPT_DIR/dev-workspace"
  kubectl apply -k "$SCRIPT_DIR/managed-workspace"
}

create_quay_secret() {
  podman login --username "$QUAY_ROBOT_ACCOUNT" --authfile "$tempDir/config.json" quay.io

  kubectl create secret generic "$QUAY_SECRET_NAME" -n "$NAMESPACE" \
      --from-file=.dockerconfigjson="$tempDir/config.json" --type=kubernetes.io/dockerconfigjson
}

create_cosign_secret() {
  cosign public-key --key k8s://tekton-chains/signing-secrets > "$tempDir/cosign.pub"
  kubectl create secret generic $COSIGN_SECRET_NAME -n "$NAMESPACE" --from-file="$tempDir/cosign.pub"
}

create_resources
create_quay_secret
create_cosign_secret

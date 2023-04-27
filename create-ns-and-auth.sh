#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

pushd "auth" >/dev/null || exit
kustomize edit set namespace "$ARK_NS"
mkdir ../build/ns-and-auth
kustomize build . >../build/ns-and-auth/kustomized.yaml
popd >/dev/null || exit

echo "Going to create the namespace $ARK_NS and the auth pieces for a service user"
microk8s kubectl create namespace "$ARK_NS"
microk8s kubectl apply -f build/ns-and-auth/kustomized.yaml
microk8s kubectl describe sa ark-user -n "$ARK_NS"

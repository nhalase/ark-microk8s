#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

kustomize edit set namespace "$ARK_NS"
kustomize build . >build/global/kustomized.yaml

if [ $# -eq 1 ] && [ -d "$1" ]; then
  pushd "$1" >/dev/null || exit
  kustomize edit set namespace "$ARK_NS"
  mkdir -p "../build/$1"
  kustomize build . >"../build/$1/kustomized.yaml"
  popd >/dev/null || exit
  echo "Going to create and start the ARK server running the $1 map"
  microk8s kubectl apply -f build/global/kustomized.yaml
  microk8s kubectl apply -f "build/$1/kustomized.yaml"
else
  echo "Didn't get exactly one arg, got $# ! $*"
  printf "Valid map names are: %s\n" "${VALID_MAP_NAMES[*]}"
fi

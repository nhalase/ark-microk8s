#!/usr/bin/env bash

# shellcheck source=source.sh
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

if [ $# -eq 1 ] && [ -d "$1" ]; then
  microk8s kubectl -n "$ARK_NS" delete sts "$1"
  microk8s kubectl -n "$ARK_NS" delete svc "$1"
else
  echo "Didn't get exactly one arg, got $# ! $*"
  printf "Valid map names are: %s\n" "${VALID_MAP_NAMES[*]}"
fi

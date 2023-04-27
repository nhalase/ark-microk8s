#!/usr/bin/env bash

# shellcheck source=source.sh
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

echo "Going to delete the namespace $ARK_NS and the auth pieces for a service user"
microk8s kubectl -n "$ARK_NS" delete rolebinding ark-user-rb
microk8s kubectl -n "$ARK_NS" delete role ark-user-general-access
microk8s kubectl -n "$ARK_NS" delete sa ark-user
microk8s kubectl delete namespace "$ARK_NS"

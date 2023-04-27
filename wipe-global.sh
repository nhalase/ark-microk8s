#!/usr/bin/env bash

# shellcheck source=source.sh
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

microk8s kubectl -n "$ARK_NS" delete cm arkmanager-main-cfg
microk8s kubectl -n "$ARK_NS" delete cm player-lists
microk8s kubectl -n "$ARK_NS" delete secret server-secrets

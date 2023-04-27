#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

pod="$1-0"
shift

microk8s kubectl -n "$ARK_NS" exec "$pod" -- "$@"

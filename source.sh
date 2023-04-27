#!/usr/bin/env bash

# convenience
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$SCRIPT_DIR" &>/dev/null && pwd -P)"

ARK_NS="${ARK_NS-ark}"
ARK_TZ="${ARK_TZ-UTC}"
VALID_MAP_NAMES=()

for d in */; do
  if [ -f "$d/ark-service.yaml" ]; then
    VALID_MAP_NAMES+=("$(basename "$d")")
  fi
done

export ARK_NS
export ARK_TZ
export VALID_MAP_NAMES
export SCRIPT_DIR

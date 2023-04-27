#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/source.sh"

set -u

touch AllowedCheaterSteamIDs.txt
touch PlayersExclusiveJoinList.txt
touch PlayersJoinNoCheck.txt
if [ ! -f ark-server-secrets.env ]; then
  echo "SERVERPASSWORD=changeit" >ark-server-secrets.env
  echo "ADMINPASSWORD=changeit" >>ark-server-secrets.env
fi
touch ark-server-secrets.env
if [ ! -f main.cfg ]; then
  cp main.cfg.sample main.cfg
fi
touch main.cfg

for d in "${VALID_MAP_NAMES[@]}"; do
  f="$d/${d}-secrets.env"
  if [ ! -f "$f" ]; then
    echo "TZ=$ARK_TZ" >"$f"
  else
    touch "$f"
  fi
done

echo "put steam user ids in AllowedCheaterSteamIDs.txt, PlayersExclusiveJoinList.txt, and PlayersJoinNoCheck.txt (one id per line)"
echo "be sure you change the values in ark-server-secrets.env!"
echo "be sure you change the values in main.cfg!"
printf "be sure you change the values in %s-secrets.env!\n" "${VALID_MAP_NAMES[@]}"

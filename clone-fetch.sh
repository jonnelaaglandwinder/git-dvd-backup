#!/bin/bash

fail() {
  echo "$@"
  exit 1
}

root="$(dirname "${BASH_SOURCE[0]}")"

[ -n "$REPO_BASE" ] || fail "\$REPO_BASE needs to be set"
[ -f "$root"/repos.list ] || fail "repos.list missing in script root"

set -e

cd "$root"
read -d '' repos < repos.list || true

clone() (
  echo "Cloning $1"
  set -x

  git clone "$REPO_BASE"/"$1" repos/"$1"
)

fetch() (
  echo "Fetching $1"
  set -x

  cd repos/"$1"
  git fetch --all
)

for repo in $repos; do
  if [ -d repos/"$repo" ]; then
    fetch "$repo"
  else
    clone "$repo"
  fi
done

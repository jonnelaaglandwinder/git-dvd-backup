#!/bin/bash

fail() {
  echo "$@"
  exit 1
}

[ -n "$DEV" ] || fail "\$DEV needs to be set to the target cdrom device"
[ -n "$VOLID_PREFIX" ] || fail "\$VOLID_PREFIX needs to be set"
export REPO_BASE

set -e

root="$(dirname "${BASH_SOURCE[0]}")"

read -d '' -a repos < "$root"/repos.list || true

temp=$(mktemp -d)
trap "rm -rf $temp" EXIT

date="$(date +%Y-%m-%d)"
mkdir -p "$temp"/"$date"

create_bundle() (
  cd "$root"/repos/"$1"

  set -x
  git bundle create "$temp"/"$date"/"$1".pack --all
)

echo "Cloning/fetching repositories..."

"$root"/clone-fetch.sh

(
  echo "Creating bundles..."

  for repo in "${repos[@]}"; do
    create_bundle "$repo"
  done

  echo "Burning to disk..."

  cd "$temp"
  xorriso -dev "$DEV" \
  -abort_on FATAL \
  -assert_volid "$VOLID_PREFIX-*" FATAL \
  -volid "$VOLID_PREFIX-$date" \
  -for_backup \
  -add *

  echo "Done!"
)

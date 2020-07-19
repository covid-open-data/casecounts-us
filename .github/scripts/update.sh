#!/bin/bash
###############################################################################
# Execution Script.
###############################################################################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_GIT_URL="git@github.com:covid-open-data/xform-template.git"
TMP_DIR=$(mktemp -d)

if git clone "${SOURCE_GIT_URL}" "${TMP_DIR}"; then
  rsync --exclude "update.sh" "${TMP_DIR}/.github/scripts" "${SCRIPT_DIR}"
  cp -R "${TMP_DIR}/.github/actions/git-push" "${SCRIPT_DIR}/../actions"
  echo ".github source updated. Check git diff before committing changes."
  echo "Update succeeded."
else
  echo "Update failed."
fi


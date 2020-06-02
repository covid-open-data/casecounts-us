#!/bin/bash
###############################################################################
# Docker container entrypoint script.
###############################################################################

if [ -z "${GITHUB_WORKSPACE}" ]; then
  echo "GITHUB_WORKSPACE not set, aborting."
  exit 1
fi

if [ -z "${GIT_EMAIL}" ]; then
  echo "GIT_EMAIL not set, using SYSTEM@users.noreply.github.com."
  GIT_EMAIL="SYSTEM@users.noreply.github.com"
fi

if [ -z "${GIT_NAME}" ]; then
  echo "GIT_NAME not set, using SYSTEM."
  GIT_NAME="SYSTEM"
fi

cd "${GITHUB_WORKSPACE}"

.github/actions/git-push/install.sh
INSTALL_STATUS=$?

if [ ${INSTALL_STATUS} -ne 0 ]; then
  echo "Install failed."
  exit 1
fi

cd "${GITHUB_WORKSPACE}/output"

git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"

if $(git status . | grep -q "Changes not staged for commit"); then
  echo "Staging changes."
  git add .
fi

if $(git status . | grep -q "Changes to be committed"); then

  if [ -z "${SKIP_COMMIT}" ]; then
    echo "Committing changes."
    git commit -m "Auto commit: $(date)"
  else
    echo "Skipping git commit..."
  fi

fi

if [ -z "${SKIP_PUSH}" ]; then
  echo "Pushing changes."
  git push --force
else
  echo "Skipping git push..."
fi
PUSH_STATUS=$?

if [ ${PUSH_STATUS} -eq 0 ]; then
  echo "Success."
else
  echo "Fail."
fi
exit ${PUSH_STATUS}

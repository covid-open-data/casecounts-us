#!/bin/bash
###############################################################################
# Execution Script.
###############################################################################
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
cd "${GITHUB_WORKSPACE}/output"

# Open the permissions on all output files before committing otherwise these files
# will be owned by the root user that runs this action in docker. This will prevent
# permissions issues when pulled locally for development.
execOrExit chmod -R a+rw "${GITHUB_WORKSPACE}/output"

execOrExit git config --global user.email "${GIT_EMAIL}"
execOrExit git config --global user.name "${GIT_NAME}"

if $(git status . | grep -q "Changes not staged for commit"); then
  echo "Staging changes."
  execOrExit git add .
fi

if $(git status . | grep -q "Changes to be committed"); then

  if [ -z "${SKIP_COMMIT}" ]; then
    echo "Committing changes."
    execOrExit git commit -m "Auto commit: $(date)"
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

exit ${PUSH_STATUS}

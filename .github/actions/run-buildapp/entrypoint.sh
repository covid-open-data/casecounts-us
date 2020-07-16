#!/bin/bash
###############################################################################
# Docker container entrypoint script.
###############################################################################

BUILDAPP_COMMAND=$@

if [ -z "${GITHUB_WORKSPACE}" ]; then
  echo "GITHUB_WORKSPACE not set, aborting."
  exit 1
fi

if [ -z "${BUILDAPP_COMMAND}" ]; then
  echo "buildapp-command not provided, aborting."
  exit 1
fi

cd "${GITHUB_WORKSPACE}"

.github/actions/run-buildapp/install.sh
INSTALL_STATUS=$?

if [ ${INSTALL_STATUS} -ne 0 ]; then
  echo "Install failed."
  exit 1
fi

echo "Executing: ${BUILDAPP_COMMAND}"
eval ${BUILDAPP_COMMAND}
BUILDAPP_STATUS=$?

if [ ${BUILDAPP_STATUS} -eq 0 ]; then
  echo "Success."
else
  echo "Fail."
fi

exit ${BUILDAPP_STATUS}

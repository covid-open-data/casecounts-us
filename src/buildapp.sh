#!/bin/bash
###############################################################################
# Install buildapp specific dependencies and execute the buildapp.
###############################################################################

INSTALL_FILE="${GITHUB_WORKSPACE}/src/install.sh"

if [ -f "${INSTALL_FILE}" ]; then
  echo "Installing buildapp dependencies..."
  ${INSTALL_FILE}
  INSTALL_STATUS=$?

  if [ ${INSTALL_STATUS} -ne 0 ]; then
    echo "Dependency install failed."
    exit 1
  else
    echo "Dependency install succeeded."
  fi
fi

# The command to execute the buildapp.
Rscript "${GITHUB_WORKSPACE}/src/buildapp.R"
exit $?

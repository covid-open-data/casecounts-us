#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install dependencies.
###############################################################################
installAptPackages apt-utils git
git --version
exit $?

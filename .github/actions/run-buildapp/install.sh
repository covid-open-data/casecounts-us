#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install base container dependencies.
###############################################################################
R --version
exit $?

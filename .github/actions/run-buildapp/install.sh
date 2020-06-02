#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install base container dependencies.
###############################################################################
installAptPackages apt-utils software-properties-common dirmngr apt-transport-https
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran36/' --yes
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys "E298A3A825C0D65DFD57CBB651716619E084DAB9"
apt-get update
installAptPackages r-base r-base-core r-base-dev r-recommended
R --version
exit $?

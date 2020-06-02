#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install buildapp specific dependencies.
###############################################################################

installAptPackages r-cran-tidyverse

R -e "remotes::install_github('covid-open-data/geoutils')"
R -e "remotes::install_github('covid-open-data/geocard')"
R -e "remotes::install_github('covid-open-data/casecountapp')"

exit 0

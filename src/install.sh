#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install buildapp specific dependencies.
###############################################################################

execOrExit R -e "remotes::install_github('hafen/trelliscopejs@new-features')"
execOrExit R -e "remotes::install_github('covid-open-data/geoutils')"
execOrExit R -e "remotes::install_github('covid-open-data/geocard')"
execOrExit R -e "remotes::install_github('covid-open-data/casecountapp')"
exit 0

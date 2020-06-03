#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install buildapp specific dependencies.
###############################################################################

installAptPackages r-cran-tidyverse
# installAptPackages r-cran-ggthemes
# installAptPackages r-cran-isoband
# installAptPackages r-cran-checkmate
# installAptPackages r-cran-diptest
# installAptPackages r-cran-mclust
# installAptPackages r-cran-webshot
# installAptPackages r-cran-autocogs
# installAptPackages r-cran-DistributionUtils

installAptPackages nodejs
installAptPackages npm

npm install netlify-cli -g

R -e "remotes::install_github('hafen/trelliscopejs@new-features')"
R -e "remotes::install_github('covid-open-data/geoutils')"
R -e "remotes::install_github('covid-open-data/geocard')"
R -e "remotes::install_github('covid-open-data/casecountapp')"

exit 0

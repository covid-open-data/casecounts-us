export DEBIAN_FRONTEND=noninteractive

# Install packages via apt-get.
# Args: package names
# Example: installAptPackages git r-base other-pkg1 other-pkg2
installAptPackages() {
  if  [ -z "${APT_GET_UPDATED}" ]; then
    echo "Updating apt-get..."
    apt-get update
    export APT_GET_UPDATED=1
  fi

  for PACKAGE_NAME in "$@"; do
    if ! $(apt -qq list ${PACKAGE_NAME} 2>/dev/null | grep -qE "(installed|upgradeable)"); then
      echo "Installing package: ${PACKAGE_NAME}"

      apt-get install -y "${PACKAGE_NAME}"
      INSTALL_STATUS=$?

      if [ ${INSTALL_STATUS} -ne 0 ]; then
        echo "Package install failed. Aborting."
        exit 1
      fi
    fi
  done
}

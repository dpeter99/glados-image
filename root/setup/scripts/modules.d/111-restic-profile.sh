#!/usr/bin/env bash

set -ouex pipefail

#### Variables

# Specify a version for stability instead of using master branch
# This ensures consistent installations and prevents breaking changes
RESTICPROFILE_VERSION="latest"

# Installation directory
INSTALL_DIR="/usr/bin"

# Temporary directory for downloads
TMP_DIR=$(mktemp -d)

echo "Installing resticprofile ${RESTICPROFILE_VERSION}"

# Change to temporary directory for downloads
cd "${TMP_DIR}"

# Use latest installer script from master branch
SCRIPT_URL="https://raw.githubusercontent.com/creativeprojects/resticprofile/master/install.sh"

# Download the installation script
echo "Downloading resticprofile installation script from ${SCRIPT_URL}..."
curl -LO "${SCRIPT_URL}"

# Make the installation script executable
chmod +x install.sh

# Run the installation script
echo "Running installation script..."
./install.sh -b "${INSTALL_DIR}" "${RESTICPROFILE_VERSION}"

# Verify installation
echo "Verifying installation..."
if [ ! -f "${INSTALL_DIR}/resticprofile" ]; then
    echo "ERROR: Installation failed, resticprofile binary not found"
    exit 1
fi

# Display version information
echo "Installed resticprofile version:"
"${INSTALL_DIR}/resticprofile" version

# Clean up temporary files
echo "Cleaning up..."
cd - > /dev/null
rm -rf "${TMP_DIR}"

echo "resticprofile installation completed successfully"

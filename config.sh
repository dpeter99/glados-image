#!/bin/bash
# config.sh - Main entry point for configuration system

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd $SCRIPT_DIR

export CONF_DIR="${SCRIPT_DIR}/conf"
export LIB_DIR="${SCRIPT_DIR}/lib"

# Source helper functions
if [ -f "${LIB_DIR}/utils.sh" ]; then
  source "${LIB_DIR}/utils.sh"
else
  echo "Helper functions not found! Please install them first."
  exit 1
fi

# Show banner
banner "Profile Setup & Configuration"

# Parse arguments and set environment
source "${LIB_DIR}/parse-args.sh"

# Load profile
source "${LIB_DIR}/load-profile.sh"

# Install COPR repositories
source "${LIB_DIR}/install-copr.sh"

# Install packages
source "${LIB_DIR}/install-packages.sh"

# Process modules
source "${LIB_DIR}/process-modules.sh"

# Completion
section "Setup complete for profile: $PROFILE_NAME"
success_banner "All tasks completed successfully!"
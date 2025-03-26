#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd $SCRIPT_DIR

export CONF_DIR="${SCRIPT_DIR}/conf"

# Source helper functions
if [ -f "${CONF_DIR}/utils.sh" ]; then
  source "${CONF_DIR}/utils.sh"
else
  echo "Helper functions not found! Please install them first."
  exit 1
fi

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  error "This script must be run as root"
  sudo -Es "$0" "$@"
  exit 1
fi

# Show banner
banner "Profile Setup & Configuration"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -d | --debug)
    export DEBUG=yes
    debug "DEBUG is set to $DEBUG"
    shift # past argument
    ;;
  esac
done

export HOST=$HOSTNAME



if ! [[ -z $CONTAINER_ID ]]; then
  debug "CONTAINER_ID is set to $CONTAINER_ID"
  PROFILE="${CONTAINER_ID}"
fi

PROFILE_FILE="${CONF_DIR}/profiles.d/${PROFILE}.toml"

if [ ! -f "$PROFILE_FILE" ]; then
  error "Profile not found: $PROFILE"
  exit 1
fi


# Check if yq is installed
if ! command -v yq &> /dev/null; then
  warning "yq not found. Installing dependencies..."
  dnf install -y yq
  task "Installed yq"
fi

# Get profile information using tomlq
PROFILE_NAME=$(yq -r '.name' "$PROFILE_FILE")
PROFILE_DESC=$(yq -r '.description' "$PROFILE_FILE")

section "Setting up profile: ${YELLOW}${PROFILE_NAME}${RESET}"
info "Description: $PROFILE_DESC"

# Enable COPR repositories
section "Enabling COPR repositories"
COPR_REPOS=$(yq -r '.packages.copr[]' "$PROFILE_FILE" 2>/dev/null || echo "")

if [ -n "$COPR_REPOS" ]; then
  for repo in $COPR_REPOS; do
    subtask "Enabling COPR repository: $repo"
    gum spin --spinner dot --title "Working..." -- \
      dnf copr enable -y "$repo" &> /dev/null

    if [ $? -eq 0 ]; then
      task "Enabled COPR repository: $repo"
    else
      warning "Failed to enable COPR repository: $repo"
    fi
  done
else
  info "No COPR repositories specified"
fi

# Install packages
section "Installing packages"
PACKAGES=$(yq -r '.packages.install[]' "$PROFILE_FILE" 2>/dev/null || echo "")

if [ -n "$PACKAGES" ]; then
  info "Installing the following packages:"

  # Show package list with gum
  echo "$PACKAGES" | tr ' ' '\n' | gum choose --no-limit --height 15 --selected-prefix "⦿ " --unselected-prefix "○ " --selected.foreground 46

  gum spin --spinner dot --title "Installing packages..." -- \
    dnf install -y $PACKAGES

  if [ $? -eq 0 ]; then
    task "Successfully installed all packages"
  else
    warning "Some packages may have failed to install"
  fi
else
  info "No packages specified"
fi

# Process modules
section "Processing modules"
MODULES=$(yq -r '.modules.enabled[]' "$PROFILE_FILE" 2>/dev/null || echo "")

if [ -n "$MODULES" ]; then
  for module in $MODULES; do
    info "Installing module: $module"

    if [ -f "${CONF_DIR}/modules.d/$module.sh" ]; then
      gum style \
        --foreground 250 --border normal --border-foreground 250 \
        --width 70 --margin "0 0 1 0" --padding "0 1" --align center \
        "Module: $module"

      if bash "${CONF_DIR}/modules.d/$module.sh"; then
        task "Successfully installed module: $module"
      else
        warning "Module installation may have issues: $module"
      fi

      # Draw a separator line
      printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    else
      error "Module installation script not found for $module"
    fi
  done
else
  info "No modules specified"
fi

section "Setup complete for profile: ${YELLOW}${PROFILE_NAME}${RESET}"
echo "${BOLD}${GREEN}All tasks completed successfully!${RESET}"
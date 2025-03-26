#!/bin/bash
# load_profile.sh - Load and validate the selected profile

PROFILE_FILE="${CONF_DIR}/profiles.d/${PROFILE}.toml"

if [ ! -f "$PROFILE_FILE" ]; then
  error "Profile not found: $PROFILE"
  exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
  warning "yq not found. Installing dependencies..."
  spinner "Installing yq" sudo dnf install -y yq
  task "Installed yq"
fi

# Get profile information using yq
PROFILE_NAME=$(yq -r '.name // "'"$PROFILE"'"' "$PROFILE_FILE")
PROFILE_DESC=$(yq -r '.description // "No description provided"' "$PROFILE_FILE")

section "Setting up profile: $PROFILE_NAME"
info "Description: $PROFILE_DESC"

# Export profile variables for use in other scripts
export PROFILE_NAME
export PROFILE_DESC
export PROFILE_FILE

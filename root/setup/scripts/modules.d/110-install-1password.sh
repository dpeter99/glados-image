#!/bin/sh
set -eu

# Prepare staging directory
mkdir -p /var/opt # -p just in case it exists

dnf install -y 1password 1password-cli

# And then we do the hacky dance!
mv /var/opt/1Password /usr/lib/opt/1Password # move this over here

# Create a symlink /usr/bin/1password => /opt/1Password/1password
# Remove the default link to the executable and create a new one
rm /usr/bin/1password
ln -s /opt/1Password/1password /usr/bin/1password
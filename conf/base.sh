#!/bin/bash

#. "./lib/lib.sh"

print_step "Adding base packages"

dnf_install_package "wl-clipboard" "gedit"

dnf_install_package "git" "git-lfs" "git-email" "gh"

dnf_enable_copr "atim/lazygit" "atim/lazydocker"
dnf_install_package "lazydocker" "lazygit"

sudo tee -a /etc/yum.repos.d/fury.repo > /dev/null <<EOT
[fury]
name=Gemfury Private Repo
baseurl=https://yum.fury.io/rsteube/
enabled=1
gpgcheck=0
EOT

dnf_install_package "nu" "zsh" "fish" "carapace-bin"

dnf_install_package "xz"

dnf_install_package "jq"

dnf_install_package "htop"

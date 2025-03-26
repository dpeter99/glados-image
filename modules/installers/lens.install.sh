#!/bin/bash

print_INFO "Installing Lens"
dnf_install_from_repo https://downloads.k8slens.dev/rpm/lens.repo lens

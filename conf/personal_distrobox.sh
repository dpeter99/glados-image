#!/bin/bash

. "./lib/lib.sh"

. "${SCRIPT_DIR}"/conf/base.sh

print_step "Adding personal packages"

dnf_install_package "gcc" "gcc-c++" "cmake" "ninja-build"
dnf_install_package "SDL2" "SDL2-devel"
dnf_install_package "vulkan-tools" "vulkan-loader-devel" "vulkan-validation-layers-devel vulkan-validation-layers"
dnf_install_package "kubernetes-client" "helm"

dnf_submit_install


install_module "brew"

#install_module "talosctl"
#install_module "talhelper"
#install_module "lens"
#install_module "fluxcd"
#install_module "cilium-cli"

run_module "host-docker-expose"

export SHELL_TO_USE=/bin/fish
setup_shell

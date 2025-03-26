#!/bin/bash

DNF_PACKAGES=""
COPR_ENABLE=""


# Add a packages to the list of packages to install
dnf_install_package(){
  DNF_PACKAGES="$DNF_PACKAGES $@"
}

# Add a repo to the list of repos to install from and install a package from it
dnf_install_from_repo(){
  run_indented dnf config-manager --add-repo $1
  shift
  dnf_install_package $@
}

# Add a copr to the list of coprs to enable
dnf_enable_copr(){
  COPR_ENABLE="$COPR_ENABLE $@"
}

dnf_submit_install(){
  print_step '--- Enabling copr repositories ---'
  print_as_table $COPR_ENABLE

  if [ -n "$COPR_ENABLE" ]; then
    for copr in $COPR_ENABLE; do
      print_INFO "Enabling copr $copr" | indent
      print_DEBUG "dnf copr enable -y $copr"
      run_indented sudo dnf copr enable -y $copr
    done
    COPR_ENABLE=""
  fi

  print_step '--- Installing packages ---'
  print_as_table $DNF_PACKAGES

  if [ -n "$DNF_PACKAGES" ]; then
    print_DEBUG "dnf install -y $DNF_PACKAGES"
    run_indented sudo dnf install -y $DNF_PACKAGES

    DNF_PACKAGES=""
  fi
}
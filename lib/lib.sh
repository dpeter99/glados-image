#!/bin/bash

[[ "${_CONFIG_LIB:-""}" == "yes" ]] && return 0
_CONFIG_LIB=yes

FULL_PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

is_atomic() {
  if command -v rpm-ostree &> /dev/null
  then
      export IS_ATOMIC=true
  else
      export IS_ATOMIC=false
  fi;
}

setup_shell(){
    if [ -f $SHELL_TO_USE ]; then
        chsh -s $SHELL_TO_USE
    fi
}


. "$SCRIPT_DIRECTORY/print.sh"

. "$SCRIPT_DIRECTORY/dnf.sh"
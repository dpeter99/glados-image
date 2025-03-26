#!/bin/bash

print_header (){
    echo "#########################################"
    echo "${1}"
    echo "#########################################"
}

export STEP_COUNT=0
export STEP_NUMBER=0

indent() { sed 's/^/  /'; }

run_indented() {
  local indent=${INDENT:-"    "}
  { "$@" 2> >(sed "s/^/$indent/g" >&2); } | sed "s/^/$indent/g"
  return ${PIPESTATUS[0]}
}

suppress()
{
  rm --force /tmp/suppress.out 2> /dev/null;
  ${1+"$@"} > /tmp/suppress.out 2>&1 || cat /tmp/suppress.out;
  rm /tmp/suppress.out;
}

print_step(){
    echo "[${STEP_NUMBER}/${STEP_COUNT}] ${1}"
    STEP_NUMBER=$((STEP_NUMBER+1))
}
debug_step(){
    print_DEBUG "DEBUG: ${STEP_NUMBER} - ${STEP_COUNT}"
}

print_INFO(){
    echo "INFO: ${1}"
}

print_DEBUG(){
    if [[ "$DEBUG" == "yes" ]]; then
        echo "DEBUG: ${1}"
    fi
}

print_ERROR(){
    echo "ERROR: ${1}"
}

print_as_table(){
    echo ${@} | column -t -s ' '
}
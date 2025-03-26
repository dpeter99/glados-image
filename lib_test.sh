#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

PATH="${SCRIPT_DIR}:${PATH}"

. ${SCRIPT_DIR}/lib/lib.sh

fail() {
    echo "Failed: $1"
    return 1
}
success() {
    echo "Success: $1"
    return 0
}

echo "Running tests"
echo "[] Print indent"
echo "This is a test" | indent
echo "[] Print run_indented"
run_indented echo "This is a test"
echo "[] Print suppress"
suppress run_indented success "This is successful"
suppress run_indented fail "This is a test"
#!/bin/sh
set -eu

echo "##################################"
echo "Installing Nvidia drivers"
echo "##################################"

printf "Kernel version: \n RPM: $(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel) \n uname: $(uname -r) \n"

QUALIFIED_KERNEL="$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel)"

cat >/tmp/fake-uname <<EOF
#!/usr/bin/env bash

if [ "\$1" == "-r" ] ; then
  echo ${QUALIFIED_KERNEL}
  exit 0
fi

exec /usr/bin/uname \$@
EOF
install -Dm0755 /tmp/fake-uname /tmp/bin/uname

PATH=/tmp/bin:$PATH

dnf install -y akmod-nvidia
PATH=/tmp/bin:$PATH akmods --force --kernels "$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel)"
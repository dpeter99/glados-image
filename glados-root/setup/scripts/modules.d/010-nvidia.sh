#!/bin/bash
set -euox pipefail
# Cehck if NVIDIA_ENABLED is set to false and exit if it is
if [ "${NVIDIA_ENABLED}" = "false" ]; then
  echo "NVIDIA_ENABLED is set to false, skipping Nvidia drivers installation"
  exit 0
fi

echo "##################################"
echo "Installing Nvidia drivers"
echo "##################################"

dnf install -y 'dnf-command(versionlock)'

dnf versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-uki-virt

QUALIFIED_KERNEL="$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel)"

printf "Kernel version: \n RPM: ${QUALIFIED_KERNEL} \n uname: $(uname -r) \n"

dnf install -y akmod-nvidia nvidia-container-toolkit xorg-x11-drv-nvidia-cuda

kver=$(cd /usr/lib/modules && echo *)

cat >/tmp/fake-uname <<EOF
#!/usr/bin/env bash

if [ "\$1" == "-r" ] ; then
  echo ${kver}
  exit 0
fi

exec /usr/bin/uname \$@
EOF
install -Dm0755 /tmp/fake-uname /tmp/bin/uname

# PATH=/tmp/bin:$PATH dkms autoinstall -k ${kver}
PATH=/tmp/bin:$PATH akmods --force --kernels ${kver}




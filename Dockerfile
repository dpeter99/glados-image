ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora-ostree-desktops/kinoite:${FEDORA_MAJOR_VERSION} as Base

RUN dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm  \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y \
    solaar \
    nu zsh \
    distrobox \
    podman-compose \
    dotnet-sdk-8.0  \
    kubernetes-client

COPY root /

RUN /tmp/scripts/modules.d/009-google-chrome.sh \
&&  /tmp/scripts/modules.d/010-install-1password.sh

RUN rm -rf /tmp/* /var/*

RUN dnf clean all && \
    systemctl set-default graphical.target

FROM Base as Nvidia

RUN dnf install -y \
    akmod-nvidia nvidia-container-toolkit \

RUN akmods --force --kernels "$(rpm -q --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}' kernel-devel)"

COPY glados-root /


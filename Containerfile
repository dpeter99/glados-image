ARG FEDORA_MAJOR_VERSION=41

ARG NVIDIA_ENABLED=false
ENV NVIDIA_ENABLED=${NVIDIA_ENABLED}

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
    kubernetes-client \
    webkit2gtk4.1 webkit2gtk4.0 kde-gtk-config

COPY root /

COPY glados-root /

RUN /setup/scripts/setup.sh

RUN rm -rf /tmp/* /var/*

RUN dnf clean all && \
    systemctl set-default graphical.target


ARG FEDORA_MAJOR_VERSION=42

FROM quay.io/fedora/fedora-kinoite:${FEDORA_MAJOR_VERSION} as Base

ARG NVIDIA_ENABLED=false
ENV NVIDIA_ENABLED=${NVIDIA_ENABLED}

RUN echo $(rpm -E %fedora)


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
    restic \
    buildah \
    git python3.11 python3-virtualenv rocm-hip

COPY root /

# COPY glados-root /

RUN /setup/scripts/setup.sh

RUN rm -rf /tmp/* /var/*

RUN dnf clean all && \
    systemctl set-default graphical.target


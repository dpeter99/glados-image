ARG FEDORA_MAJOR_VERSION=41

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

RUN sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm  \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf in -y \
    kmod-nvidia nvidia-container-toolkit xorg-x11-drv-nvidia \
    solaar \
    nu zsh \
    distrobox \
    podman-compose \
    dotnet-sdk-8.0  \
    kubernetes-client


COPY root/etc /etc
COPY root/usr /usr

ADD https://downloads.1password.com/linux/keys/1password.asc /etc/pki/rpm-gpg


RUN sudo dnf install -y 1password 1password-cli


RUN dnf clean all && \
    systemctl set-default graphical.target

#COPY lfarkas.repo /temp/build/

#RUN dnf config-manager addrepo --from-repofile=/temp/build/lfarkas.repo && \
#    dnf config-manager setopt lfarkas.enabled=1 && \
#    rpm -e --nodeps libfprint && \
#    dnf install -y libfprint-tod libfprint-tod-broadcom

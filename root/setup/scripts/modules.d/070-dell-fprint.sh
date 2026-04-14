
sudo dnf -y copr enable grahamwhiteuk/libfprint-tod

sudo dnf -y swap libfprint libfprint-tod
sudo dnf -y install libfprint-2-tod1-broadcom libfprint-tod-selinux
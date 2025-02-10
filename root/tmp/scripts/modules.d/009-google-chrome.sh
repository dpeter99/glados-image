
# Prepare staging directory
mkdir -p /var/opt # -p just in case it exists

dnf config-manager setopt google-chrome.enabled=1
dnf install -y google-chrome-stable

# And then we do the hacky dance!
mv /var/opt/google /usr/lib/opt/google # move this over here
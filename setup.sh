#!/bin/bash
apt update -y
apt upgrade -y

# Install docker (see: https://docs.docker.com/engine/install/ubuntu/)
echo -n "Installing Docker…"

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt update -y
apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

groupadd docker
usermod -aG docker $USER

# Install guest additions
echo -n "Installing Guest Additions…"
apt-get install -y \
        build-essential \
        dkms \
        linux-headers-$(uname -r)

mkdir -p /mnt/cdrom
mount /dev/cdrom /mnt/cdrom
cd /mnt/cdrom
sh ./VBoxLinuxAdditions.run --nox11

# Enable auto login
if [! -d "/etc/systemd/system/getty@tty1.service.d"]
then
  mkdir -p "/etc/systemd/system/getty@tty1.service.d"}
fi
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin ${USER} --noclear %I $TERM\nType=idle" | tee /etc/systemd/system/getty@tty1.service.d/override.conf

# Hide Ubuntu Server MOTD
touch ~/.hushlogin

# Hide cloud-init message output
touch /etc/cloud/cloud-init.disabled

echo -n "Rebooting in 5s…"
sleep 5 ; reboot

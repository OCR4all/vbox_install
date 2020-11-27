#!/bin/bash
apt update -y
apt upgrade -y

# Install docker (see: https://docs.docker.com/engine/install/ubuntu/)
echo -n "Installing Docker…"

sudo apt install -y docker.io

groupadd docker
usermod -aG docker ocr4all

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

# Init information script service
cp ./startup_script.sh /usr/local/bin/startup_script.sh
chmod a+x /usr/local/bin/startup_script.sh

mkdir -p /home/ocr4all/.local/share/systemd/user
cp ./startup_info.service /home/ocr4all/.local/share/systemd/user/.

systemctl --user enable startup_info.service

echo -n "Rebooting in 5s…"
sleep 5 ; reboot

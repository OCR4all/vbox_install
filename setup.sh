#!/bin/bash
apt update -y
apt upgrade -y

# Install docker
echo -n "Installing Docker…"

sudo apt install -y docker.io

# Add ocr4all user to docker user group to manage docker without being root user
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
cp /home/ocr4all/vbox_install/startup_script.sh /home/ocr4all/.
chmod a+x /home/ocr4all/startup_script.sh

echo "sh /home/ocr4all/startup_script.sh" >> /home/ocr4all/.bashrc

echo -n "Rebooting in 5s…"
sleep 5 ; reboot

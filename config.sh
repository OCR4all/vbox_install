#!/bin/bash
# Enable auto login
if [ ! -d "/etc/systemd/system/getty@tty1.service.d" ]
then
  mkdir -p "/etc/systemd/system/getty@tty1.service.d"
fi
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin ocr4all --noclear %I $TERM\nType=idle" | tee /etc/systemd/system/getty@tty1.service.d/override.conf

# Hide Ubuntu Server MOTD
touch ~/.hushlogin

# Hide cloud-init message output
touch /etc/cloud/cloud-init.disabled

if [ ! groups ocr4all | grep -q '\bvboxsf\b' ]
then
  usermod -a -G vboxsf ocr4all
fi

BASE_DIR="/home/ocr4all/ocr4all"

if [ ! -d ${BASE_DIR} ]
then
  mkdir -p ${BASE_DIR}
fi
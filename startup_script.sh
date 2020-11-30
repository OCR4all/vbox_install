#!/bin/bash
# Wait until all boot services are loaded before initiating docker.
# This is necessary because otherwise docker might try to mount the shared folders as volumes before the corresponding
# VirtualBox service made the shared folders available inside the VirtualBox
while [ ! $(systemctl is-system-running --wait) = "running" ]; do
  sleep 2
done
# Monitors whether the OCR4all docker container is already running
while [ ! "$(docker ps | grep ocr4all)" ]; do
  sleep 5
done
echo "OCR4all status: \e[92mRunning\e[39m"

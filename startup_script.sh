#!/bin/bash
while [ ! $(systemctl is-system-running --wait) = "running" ]; do
  sleep 2
done
while [ ! "$(docker ps | grep ocr4all)" ]; do
  sleep 5
done
echo "OCR4all status: \e[92mRunning\e[39m"

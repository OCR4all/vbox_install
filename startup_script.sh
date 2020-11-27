#!/bin/bash

while [ ! "$(docker ps | grep ocr4all)" ]; do
  sleep 5
done
echo "OCR4all status: \e[92mRunning\e[39m"
#!/bin/bash

while [ ! "$(docker ps | grep ocr4all)" ]; do
  sleep 5
done
echo -e "OCR4all status: \e[92mRunning"
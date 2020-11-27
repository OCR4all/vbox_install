#!/bin/bash

while [ ! "$(docker ps | grep ocr4all-devel)" ]; do
  sleep 5
done
echo "OCR4all status: 🟢"
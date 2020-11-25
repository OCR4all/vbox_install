#!/bin/bash
BASE_DIR="/home/ocr4all/ocr4all"

docker run \
    -p 8080:8080 \
    -u `id -u root`:`id -g $USER` \
    --name ocr4all \
    -v ${BASE_DIR}/data:/var/ocr4all/data \
    -v ${BASE_DIR}/models:/var/ocr4all/models/custom \
    --restart always \
    -it ls6uniwue/ocr4all

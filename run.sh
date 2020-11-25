#!/bin/bash
BASE_DIR="/home/$USER/ocr4all"

if [! groups $USER | grep -q '\bvboxsf\b']
then
  usermod -a -G vboxsf $USER
fi

if [! -d ${BASE_DIR}]
then
  mkdir -p ${BASE_DIR}
fi

docker run \
    -p 8080:8080 \
    -u `id -u root`:`id -g $USER` \
    --name ocr4all \
    -v ${BASE_DIR}/data:/var/ocr4all/data \
    -v ${BASE_DIR}/models:/var/ocr4all/models/custom \
    --restart always \
    -it ls6uniwue/ocr4all

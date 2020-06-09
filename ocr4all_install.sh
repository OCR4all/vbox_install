#!/bin/bash

set -e
ARTIFACTORY_URL=http://artifactory-ls6.informatik.uni-wuerzburg.de/artifactory/libs-snapshot/de/uniwue


# Create ocr4all directories and grant tomcat permissions
mkdir -p /var/ocr4all/data \
/var/ocr4all/models/default \
/var/ocr4all/models/custom

chmod -R g+w /var/ocr4all 
chgrp -R tomcat8 /var/ocr4all


# Make pretrained CALAMARI models available to the project environment
## Update to future calamari version v1.x.x will require new models
CALAMARI_MODELS_VERSION="1.0"
wget https://github.com/OCR4all/ocr4all_models/archive/${CALAMARI_MODELS_VERSION}.tar.gz -O /opt/ocr4all_models.tar.gz && \
mkdir -p /opt/ocr4all_models/ && \
tar -xvzf /opt/ocr4all_models.tar.gz -C /opt/ocr4all_models/ --strip-components=1 && \
rm /opt/ocr4all_models.tar.gz && \
ln -s /opt/ocr4all_models/default /var/ocr4all/models/default/default

        
# Install ocropy, make all ocropy scripts available to JAVA environment
OCROPY_COMMIT="d1472da2dd28373cda4fcbdc84956d13ff75569c"
cd /opt && git clone -b master https://gitlab2.informatik.uni-wuerzburg.de/chr58bk/mptv.git ocropy
cd ocropy && git reset --hard $OCROPY_COMMIT
python2.7 setup.py install
        
        
# Install calamari, make all calamari scripts available to JAVA environment
## calamari from source with version: v0.x.x
CALAMARI_COMMIT="d293871c40c105f38e5528944fc39f04eb7649a7"
cd /opt && git clone -b feature/pageXML_word_level https://github.com/maxnth/calamari.git
cd calamari && git reset --hard $CALAMARI_COMMIT
python3 setup.py install
        
        
# Install helper scripts to make all scripts available to JAVA environment
HELPER_SCRIPTS_COMMIT="6ecee08747c301216c7a6da54a328fdacdb4a5fe"
cd /opt && git clone -b master https://github.com/OCR4all/OCR4all_helper-scripts.git
cd OCR4all_helper-scripts && git reset --hard $HELPER_SCRIPTS_COMMIT
python3 setup.py install

        
# Download maven project
OCR4ALL_VERSION="0.3.0"
LAREX_VERSION="0.3.1"
cd /var/lib/tomcat8/webapps
wget $ARTIFACTORY_URL/OCR4all_Web/$OCR4ALL_VERSION/OCR4all_Web-$OCR4ALL_VERSION.war -O ocr4all.war
wget $ARTIFACTORY_URL/Larex/$LAREX_VERSION/Larex-$LAREX_VERSION.war -O Larex.war

mkdir $CATALINA_HOME/temp
mkdir $CATALINA_HOME/logs
        
        
# Create index.html for calling url without tool url part!
git clone https://github.com/OCR4all/docker_image
cp ./docker_image/index.html /var/lib/tomcat8/webapps/ROOT/index.html

        
# Copy larex.config
cp ./docker_image/larex.config /larex.config
rm -rf ./docker_image/

        
#Enable calamari and ocropus scripts in tomcat 
echo "PATH=$PATH:/usr/local/bin" >> /etc/default/tomcat8
echo "LAREX_CONFIG=/larex.config" >> /etc/default/tomcat8

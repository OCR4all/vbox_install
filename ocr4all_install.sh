#!/bin/bash

su
# Install dependencies system-wide and delete cache, removed supervisor docker dependency
apt-get update
apt get install -y locales git wget openjdk-8-jdk-headless tomcat8 python2.7 python3-pip python3-pil maven python-tk python-pip

pip install scikit-image numpy matplotlib scipy lxml
pip3 install lxml setuptools
rm -rf /var/lib/apt/lists/*

#Set the locale, to solve Tomcat issues with Ubuntu
locale-gen en_US.UTF-8
ENVVAR="/etc/environment"
echo "LANG=en_US.UTF-8" >> $ENVVAR
echo "LANGUAGE=\"en_US:en\"" >> $ENVVAR
echo "LC_ALL=\"en_US.UTF-8\"" >> $ENVVAR
echo "CATALINA_HOME=\"/usr/share/tomcat8\"" >> $ENVVAR


#Force Tomcat to use Java 8
        #rm /usr/lib/jvm/default-java && \
        #ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /usr/lib/jvm/default-java && \
        update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Create ocr4all directories and grant tomcat permissions
        mkdir -p /var/ocr4all/data \
                 /var/ocr4all/models/default \
                 /var/ocr4all/models/custom
        chmod -R g+w /var/ocr4all 
        chgrp -R tomcat8 /var/ocr4all


# Make pretrained CALAMARI models available to the project environment
## Update to future calamari version v1.x.x will require new models
        CALAMARI_MODELS_VERSION="0.3"
        wget https://github.com/OCR4all/ocr4all_models/archive/${CALAMARI_MODELS_VERSION}.tar.gz -O /opt$
        mkdir -p /opt/ocr4all_models/ 
        tar -xvzf /opt/ocr4all_models.tar.gz -C /opt/ocr4all_models/ --strip-components=1
        rm /opt/ocr4all_models.tar.gz
        ln -s /opt/ocr4all_models/default /var/ocr4all/models/default;

# Install ocropy, make all ocropy scripts available to JAVA environment
        OCROPY_COMMIT="d1472da2dd28373cda4fcbdc84956d13ff75569c"
        cd /opt && git clone -b master https://gitlab2.informatik.uni-wuerzburg.de/chr58bk/mptv.git ocro$
        cd ocropy && git reset --hard $OCROPY_COMMIT
        python2.7 setup.py install
        #cd /usr/local/bin
        #OCR_SCRIPT_LIST='ls ocropus-*'
        #for OCR_SCRIPT in $OCR_SCRIPT_LIST; \
        #       do ln -s /usr/local/bin/$OCR_SCRIPT /bin/$OCR_SCRIPT; \
        #done

# Install calamari, make all calamari scripts available to JAVA environment
## calamari from source with version: v0.x.x
        CALAMARI_COMMIT="ac4801e28e45149b51797508fae6cad49e46c82e"
        cd /opt && git clone -b calamari-0.3 https://github.com/Calamari-OCR/calamari.git
        cd calamari && git reset --hard $CALAMARI_COMMIT
        python3 setup.py install
        #cd /usr/local/bin
        #CALAMARI_SCRIPT_LIST='ls calamari-*'
        #for CALAMARI_SCRIPT in $CALAMARI_SCRIPT_LIST; \
        #       do ln -s /usr/local/bin/$CALAMARI_SCRIPT /bin/$CALAMARI_SCRIPT; \
        #done
# Install helper scripts to make all scripts available to JAVA environment
        HELPER_SCRIPTS_COMMIT="3e82d303d494a8de2208baf4c0044cdd268ac7dd"
        cd /opt && git clone -b master https://github.com/OCR4all/OCR4all_helper-scripts.git
        cd OCR4all_helper-scripts && git reset --hard $HELPER_SCRIPTS_COMMIT
        python3 setup.py install

# Download maven project
        OCR4ALL_VERSION="0.1.2-4"
        GTCWEB_VERSION="0.0.1-6"
        LAREX_VERSION="0.2.0"
        cd /var/lib/tomcat8/webapps
        wget $ARTIFACTORY_URL/OCR4all_Web/$OCR4ALL_VERSION/OCR4all_Web-$OCR4ALL_VERSION.war -O OCR4all_W$
        wget $ARTIFACTORY_URL/GTC_Web/$GTCWEB_VERSION/GTC_Web-$GTCWEB_VERSION.war -O GTC_Web.war
        wget $ARTIFACTORY_URL/Larex/$LAREX_VERSION/Larex-$LAREX_VERSION.war -O Larex.war

# Add webapps to tomcat
        ln -s /var/lib/tomcat8/common $CATALINA_HOME/common
        ln -s /var/lib/tomcat8/server $CATALINA_HOME/server
        ln -s /var/lib/tomcat8/shared $CATALINA_HOME/shared
        ln -s /etc/tomcat8 $CATALINA_HOME/conf
        mkdir $CATALINA_HOME/temp
        mkdir $CATALINA_HOME/webapps
        mkdir $CATALINA_HOME/logs
        ln -s /var/lib/tomcat8/webapps/OCR4all_Web.war $CATALINA_HOME/webapps
        ln -s /var/lib/tomcat8/webapps/GTC_Web.war $CATALINA_HOME/webapps
        ln -s /var/lib/tomcat8/webapps/Larex.war $CATALINA_HOME/webapps

# Put supervisor process manager configuration to container Docker artifact
#cp supervisord.conf /etc/supervisor/conf.d

# Create index.html for calling url without tool url part!
cp index.html /usr/share/tomcat8/webapps/ROOT/index.html

# Copy larex.config
cp larex.config /larex.config

echo "LAREX_CONFIG=\"/larex.config\"" >> $ENVVAR

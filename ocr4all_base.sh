#!/bin/bash

apt-get update
apt-get install 

# Installing dependencies and deleting cache
apt-get update && apt-get install -y \
    locales \
    git \
    maven \
    tomcat8 \
    openjdk-8-jdk-headless \
    python python-pip python3 python3-pip python3-pil python-tk \
    wget \
    supervisor && \
    
# Installing python dependencies    
rm -rf /var/lib/apt/lists/*
python -m pip install --upgrade pip && \
python -m pip install --upgrade -r ./requirements_py2.txt && \
python3 -m pip install --upgrade pip && \
python3 -m pip install --upgrade -r ./requirements_py3.txt && \


#Set the locale, to solve Tomcat issues with Ubuntu
locale-gen en_US.UTF-8
ENVVAR="/etc/environment"
echo "LANG=en_US.UTF-8" >> $ENVVAR
echo "LANGUAGE=\"en_US:en\"" >> $ENVVAR
echo "LC_ALL=\"en_US.UTF-8\"" >> $ENVVAR
echo "CATALINA_HOME=\"/usr/share/tomcat8\"" >> $ENVVAR
source /etc/environment.txt

#Force Tomcat to use Java 8
rm /usr/lib/jvm/default-java && \
ln -s /usr/lib/jvm/java-1.8.0-openjdk-amd64 /usr/lib/jvm/default-java && \
update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

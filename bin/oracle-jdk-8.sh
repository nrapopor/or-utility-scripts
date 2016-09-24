#!/bin/bash
RELEASE=`lsb_release -cs`
LINE_CNT=`grep  "http://ppa.launchpad.net/webupd8team" /etc/apt/sources.list | wc -l`
if [[ ! ${LINE_CNT} -gt 1 ]]; then
    sudo echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu ${RELEASE} main" | sudo tee -a /etc/apt/sources.list
    sudo echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu ${RELEASE} main" | sudo tee -a /etc/apt/sources.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
	sudo echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
fi
sudo apt-get update
sudo apt-get install oracle-java8-installer

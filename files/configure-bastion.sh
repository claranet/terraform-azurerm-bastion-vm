#!/bin/bash
set -e
set -x

sudo mv /tmp/bastion-formula/* /srv/
sudo rm -rf /tmp/bastion-formula
sudo DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' purge salt-minion salt-common
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' update
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl ntp python python-pip apt-transport-https
sudo pip install azure-cli
sudo curl -L https://bootstrap.saltstack.com | sudo bash
sudo salt-call --local --file-root=/srv/salt --pillar-root=/srv/pillar state.highstate

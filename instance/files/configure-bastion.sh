#!/bin/bash
set -e
set -x

sudo mv /tmp/bastion-formula/* /srv/
sudo rm -rf /tmp/bastion-formula
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' purge salt-minion salt-common
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' update
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl ntp python python-pip azure-cli apt-transport-https
sudo curl -L https://bootstrap.saltstack.com | sudo bash
sudo salt-call --local --file-root=/srv/salt --pillar-root=/srv/pillar state.highstate

#!/bin/bash
set -e
set -x

sudo mv /tmp/bastion-formula/* /srv/
sudo rm -rf /tmp/bastion-formula
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' purge salt-minion salt-common
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' update
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install curl ntp python python-pip
sudo pip install boto boto3
sudo curl -L https://bootstrap.saltstack.com | sudo bash
sudo salt-call --local --file-root=/srv/salt --pillar-root=/srv/pillar state.highstate

# Setup EC2-utils
cd /tmp/morea-tools/aws/ec2/
sudo pip install -r requirements.txt
sudo pip install -r requirements.txt
sudo python setup.py install
sudo rm -rf /tmp/morea-tools
sudo chmod 755 /usr/local/bin/ec2-utils

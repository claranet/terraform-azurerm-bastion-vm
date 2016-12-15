#!/bin/bash
set -e
set -x

MAX_NAME=$(($(getconf HOST_NAME_MAX)-16))
EC2_HOSTNAME=$(echo ${NAME:0:$MAX_NAME}-${IP}| tr -s '.' '-')
echo "Changing HOSTNAME to $EC2_HOSTNAME"
sudo salt-call --local network.mod_hostname "$EC2_HOSTNAME"
sudo salt-call --local file.append /etc/hosts "$(echo $IP| tr -s '-' '.') $EC2_HOSTNAME"

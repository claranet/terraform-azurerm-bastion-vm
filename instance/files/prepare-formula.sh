#!/bin/bash
set -e
set -x

# clone formula
rm -rf /tmp/bastion-formula
git clone git@bitbucket.org:morea/morea-salt-formulas.git -b 16.09.1 /tmp/bastion-formula
cd /tmp/bastion-formula
git submodule update --init --recursive

# clone morea-tools
rm -rf /tmp/morea-tools
git clone git@bitbucket.org:morea/morea-tools /tmp/morea-tools

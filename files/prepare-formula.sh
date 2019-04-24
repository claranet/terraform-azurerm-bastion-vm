#!/bin/bash
set -e
set -x

# clone formula
rm -rf /tmp/bastion-formula
git clone git@bitbucket.org:morea/morea-salt-formulas.git /tmp/bastion-formula
cd /tmp/bastion-formula
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
git submodule update --init --recursive

# clone morea-tools
rm -rf /tmp/morea-tools
git clone git@bitbucket.org:morea/morea-tools /tmp/morea-tools

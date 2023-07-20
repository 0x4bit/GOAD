#!/bin/bash

# Install git and python3
sudo apt-get update
sudo apt-get install -y git python3-venv python3-pip

# Clone GOAD repository and activate the virtual environment
git clone --branch azure https://github.com/jarrault/GOAD.git
cd GOAD/ansible
python3 -m venv .venv
source .venv/bin/activate

# Install ansible and pywinrm
python3 -m pip install --upgrade pip
python3 -m pip install ansible-core==2.12.6
python3 -m pip install pywinrm

# Install the required ansible libraries
ansible-galaxy install -r requirements.yml

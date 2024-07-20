#!/usr/bin/env bash

cd $(dirname "$0")/ansible

export ANSIBLE_COMMAND="ansible-playbook -i $(dirname "$0")/ad/GOAD/data/inventory -i $(dirname "$0")/ad/GOAD/providers/proxmox/inventory"

$(dirname "$0")/scripts/provisioning.sh

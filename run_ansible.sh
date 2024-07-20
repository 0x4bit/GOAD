#!/usr/bin/env bash

cd $(dirname "$0")/ansible

export LAB="GOAD"
export PROVIDER="proxmox"

../scripts/provisioning.sh

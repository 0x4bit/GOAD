#!/usr/bin/env bash

path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $path/packer/proxmox/scripts/sysprep
wget https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi

cd $path/packer/proxmox
./build_proxmox_iso.sh
packer init

cd $path/ad/GOAD/providers/proxmox/terraform
terraform init

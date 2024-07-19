variable "vm_config" {
  type = map(object({
    name               = string
    desc               = string
    cores              = number
    memory             = number
    clone              = string
    dns                = string
    ip                 = string
    gateway            = string
    id                 = number
  }))

  default = {
    "dc01" = {
      name               = "GOAD-DC01"
      desc               = "DC01 - windows server 2019 - 172.16.0.10"
      cores              = 2
      memory             = 3096
      clone              = "WinServer2019_x64"
      dns                = "172.16.0.2"
      ip                 = "172.16.0.10/24"
      gateway            = "172.16.0.2"
      id                 = 203
    }
    "dc02" = {
      name               = "GOAD-DC02"
      desc               = "DC02 - windows server 2019 - 172.16.0.11"
      cores              = 2
      memory             = 3096
      clone              = "WinServer2019_x64"
      dns                = "172.16.0.2"
      ip                 = "172.16.0.11/24"
      gateway            = "172.16.0.2"
      id                 = 204
    }
    "dc03" = {
      name               = "GOAD-DC03"
      desc               = "DC03 - windows server 2016 - 172.16.0.12"
      cores              = 2
      memory             = 3096
      clone              = "WinServer2016_x64"
      dns                = "172.16.0.2"
      ip                 = "172.16.0.12/24"
      gateway            = "172.16.0.2"
      id                 = 205
    }
    "srv02" = {
      name               = "GOAD-SRV02"
      desc               = "SRV02 - windows server 2019 - 172.16.0.22"
      cores              = 2
      memory             = 4096
      clone              = "WinServer2019_x64"
      dns                = "172.16.0.2"
      ip                 = "172.16.0.22/24"
      gateway            = "172.16.0.2"
      id                 = 206
    }
    "srv03" = {
      name               = "GOAD-SRV03"
      desc               = "SRV03 - windows server 2016 - 172.16.0.23"
      cores              = 2
      memory             = 4096
      clone              = "WinServer2016_x64"
      dns                = "172.16.0.2"
      ip                 = "172.16.0.23/24"
      gateway            = "172.16.0.2"
      id                 = 207
    }
    #"ws01" = {
    #  name               = "GOAD-WS01"
    #  desc               = "WS01 - windows 10 - 172.16.0.30"
    #  cores              = 2
    #  memory             = 4096
    #  clone              = "Windows10_22h2_x64"
    #  dns                = "172.16.0.2"
    #  ip                 = "172.16.0.30/24"
    #  gateway            = "172.16.0.2"
    #  id                 = 208
    #}
  }
}

resource "proxmox_virtual_environment_vm" "bgp" {
  for_each = var.vm_config

    name = each.value.name
    description = each.value.desc
    node_name   = var.pm_node
    pool_id     = var.pm_pool
    vm_id       = each.value.id

    operating_system {
      type = "win10"
    }

    cpu {
      cores   = each.value.cores
      sockets = 1
    }

    memory {
      dedicated = each.value.memory
    }

    clone {
      vm_id = lookup(var.vm_template_id, each.value.clone, -1)
      full  = var.pm_full_clone
      retries = 2
    }

    agent {
      # read 'Qemu guest agent' section, change to true only when ready
      enabled = true
    }

    network_device {
      bridge  = var.network_bridge
      model   = var.network_model
      vlan_id = var.network_vlan
    }

    lifecycle {
      ignore_changes = [
        vga,
      ]
    }

    initialization {
      datastore_id = var.storage
      dns {
        servers = [
          each.value.dns
        ]
      }
      ip_config {
        ipv4 {
          address = each.value.ip
          gateway = each.value.gateway
        }
      }
    }
}

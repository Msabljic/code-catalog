resource "proxmox_virtual_environment_vm" "this" {
  for_each    = { for vm in local.machine_map : vm.machine_name => vm }
  name        = each.key
  description = <<EOT
# Machine Information & Specifications.

Admin account

${var.base_config.default_username}

${random_password.this[each.key].result}
EOT
  #   tags        = module.naming.list_of_tags
  node_name = each.value.server_node
  vm_id     = each.value.vm_id
  started   = true

  cpu {
    cores = each.value.cpu_cores
  }
  memory {
    dedicated = each.value.memory
  }

  agent {
    enabled = true
  }

  clone {
    datastore_id = var.clone.storage
    vm_id        = var.clone.vm_id
    node_name    = var.clone.proxmox_node
    retries      = sum([var.base_config.master_nodes, var.base_config.worker_nodes, 1])
  }

  initialization {
    datastore_id = var.base_config.storage
    user_account {
      username = var.base_config.default_username
      password = random_password.this[each.key].result
      keys     = []
    }

    ip_config {
      ipv4 {
        address = join("", [each.value.cidr, regex("/.*$", var.base_config.subnet_range)])
        gateway = var.base_config.gateway
      }
    }
  }

  network_device {
    bridge   = var.base_config.network
    firewall = true
    mtu      = var.base_config.mtu
  }


  operating_system {
    type = "l26"
  }

  serial_device {}
}

resource "random_password" "this" {
  for_each         = { for vm in local.machine_map : vm.machine_name => vm }
  length           = var.base_config.password_length
  override_special = "_%@"
  special          = true
}

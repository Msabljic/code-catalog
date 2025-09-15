
resource "proxmox_virtual_environment_firewall_alias" "this" {
  for_each = { for vm in local.machine_map : vm.machine_name => vm }
  name     = each.key
  cidr     = each.value.cidr
  comment  = "managed by terraform"

  depends_on = [proxmox_virtual_environment_vm.this]
}

resource "proxmox_virtual_environment_firewall_ipset" "this" {
  for_each  = { for ipset in local.ipset_composite : ipset.itorator => ipset }
  node_name = each.value.server_node
  vm_id     = each.value.vm_id

  name    = each.value.name
  comment = "Managed by Terraform"

  dynamic "cidr" {
    for_each = [for ip in each.value.cidr : ip]
    content {
      name    = cidr.value
      comment = "managed by terraform"
    }
  }
  depends_on = [proxmox_virtual_environment_vm.this]
}

resource "proxmox_virtual_environment_firewall_options" "this" {
  for_each = { for vm in local.machine_map : vm.machine_name => vm }

  node_name  = each.value.server_node
  vm_id      = each.value.vm_id
  enabled    = "true"
  depends_on = [proxmox_virtual_environment_vm.this]
}


resource "proxmox_virtual_environment_firewall_rules" "this" {
  for_each  = { for vm in local.machine_map : vm.machine_name => vm }
  node_name = each.value.server_node
  vm_id     = each.value.vm_id

  dynamic "rule" {
    for_each = { for rule in lookup(local.config_collector, each.value.type, null).firewall_rules : rule.rule_id => rule }
    content {
      type    = rule.value.direction
      proto   = rule.value.protocol
      enabled = true
      action  = rule.value.action
      dport   = rule.value.destination_port
      source  = rule.value.source
      log     = rule.value.log
      comment = rule.value.comment
    }
  }

  depends_on = [proxmox_virtual_environment_vm.this]
}
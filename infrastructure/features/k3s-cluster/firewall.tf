
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

# resource "proxmox_virtual_environment_firewall_options" "this" {
#   for_each = { for vm in local.machine_map : vm.machine_name => vm }

#   node_name = each.value.server_node
#   vm_id     = each.value.vm_id

#   dhcp          = var.dhcp
#   enabled       = var.enabled
#   ipfilter      = var.ipfilter
#   log_level_in  = var.log_level_in
#   log_level_out = var.log_level_out
#   macfilter     = var.macfilter
#   ndp           = var.ndp
#   input_policy  = var.input_policy
#   output_policy = var.output_policy
#   radv          = var.radv
#   depends_on    = [proxmox_virtual_environment_vm.this]
# }


resource "proxmox_virtual_environment_firewall_rules" "this" {
  for_each  = { for vm in local.machine_map : vm.machine_name => vm }
  node_name = each.value.server_node
  vm_id     = each.value.vm_id

  dynamic "rule" {
    for_each = { for rule in lookup(local.config_collector, each.value.type, null).firewall_rules : rule.rule_id => rule }
    content {
      type    = rule.value.direction
      enabled = true
      #   iface   = rule.value.interface
      action = rule.value.action
      #   comment = rule.value.comment
      #   dest    = rule.value.destination
      dport  = rule.value.destination_port
      source = rule.value.source
      #   sport   = rule.value.source_port
      #   proto   = rule.value.protocol
      #   macro   = rule.value.macro
      log = rule.value.log
    }
  }

  #   depends_on = [proxmox_virtual_environment_vm.this]
}
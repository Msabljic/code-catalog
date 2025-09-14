locals {
  master_map = [for config in range(var.base_config.master_nodes) : {
    machine_name = "${var.base_config.master_name_prefix}-${config + 1}"
    server_node  = element(var.base_config.proxmox_nodes, config)
    vm_id        = var.base_config.vm_id + config
    cpu_cores    = var.base_config.master_cpu_cores
    memory       = var.base_config.master_memory
    cidr         = cidrhost(var.base_config.subnet_range, config)
    type         = "master"
  }]
  worker_map = [for config in range(var.base_config.worker_nodes) : {
    machine_name = "${var.base_config.worker_name_prefix}-${config + 1}"
    server_node  = element(var.base_config.proxmox_nodes, config)
    vm_id        = var.base_config.vm_id + var.base_config.master_nodes + config
    cpu_cores    = var.base_config.worker_cpu_cores
    memory       = var.base_config.worker_memory
    cidr         = cidrhost(var.base_config.subnet_range, var.base_config.master_nodes + config)
    type         = "worker"
  }]
  machine_map = concat(local.master_map, local.worker_map)
  config_collector = {
    master = {
      ip_collection = slice(local.machine_map[*].cidr, 0, var.base_config.master_nodes)
      firewall_rules = [{
        rule_id          = "ssh-control"
        direction        = "in"
        destination_port = 22
        log              = "notice"
        action           = "ACCEPT"
        source           = var.operation.executer_ip
      }]
    }
    worker = {
      ip_collection = slice(local.machine_map[*].cidr, var.base_config.master_nodes, var.base_config.worker_nodes + var.base_config.master_nodes)
      firewall_rules = [{
        rule_id          = "kube-access"
        direction        = "in"
        action           = "ACCEPT"
        destination_port = "443,6443"
        log              = "notice"
        source           = var.operation.executer_ip
      }]
    }
  }
  ipset_composite = flatten([for vm in local.machine_map : [for key, value in local.config_collector : {
    itorator    = join("-", [vm.vm_id, key])
    vm_id       = vm.vm_id
    server_node = vm.server_node
    name        = "k3s-${key}-list"
    cidr        = value.ip_collection
  }]])
  file_base64 = base64encode("[master] ${join("", local.master_map[*].cidr)} [node] ${join("", local.worker_map[*].cidr)} [k3s_cluster:children] master node")
}

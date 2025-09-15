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
        comment          = "Secure shell session access for script execution"
        direction        = "in"
        destination_port = "22"
        log              = "notice"
        action           = "ACCEPT"
        protocol         = "tcp"
        source           = var.operation.executer_ip
        },
        {
          rule_id          = "K3s-api"
          comment          = "K3s supervisor and Kubernetes API Server"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "6443"
          protocol         = "tcp"
          log              = "notice"
          source           = "+k3s-worker-list"
        },
        {
          rule_id          = "ha-etcd"
          comment          = "Required only for HA with embedded etcd"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "2379,2380"
          protocol         = "tcp"
          log              = "nolog"
          source           = "+k3s-master-list"
        },
        {
          rule_id          = "flannel-master"
          comment          = "Flannel VXLAN master node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "8472,51820,51821"
          protocol         = "udp"
          log              = "nolog"
          source           = "+k3s-master-list"
        },
        {
          rule_id          = "flannel-worker"
          comment          = "Flannel VXLAN worker node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "8472,51820,51821"
          protocol         = "udp"
          log              = "nolog"
          source           = "+k3s-worker-list"
        },
        {
          rule_id          = "monitor-worker"
          comment          = "Kubelet metrics worker node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "10250"
          protocol         = "tcp"
          log              = "nolog"
          source           = "+k3s-worker-list"
        },
        {
          rule_id          = "monitor-master"
          comment          = "Kubelet metrics master node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "10250"
          protocol         = "tcp"
          log              = "nolog"
          source           = "+k3s-master-list"
      }]
    }
    worker = {
      ip_collection = slice(local.machine_map[*].cidr, var.base_config.master_nodes, var.base_config.worker_nodes + var.base_config.master_nodes)
      firewall_rules = [{
        rule_id          = "ssh-control"
        comment          = "Secure shell session access for script execution"
        direction        = "in"
        destination_port = "22"
        log              = "notice"
        action           = "ACCEPT"
        protocol         = "tcp"
        source           = var.operation.executer_ip
        },
        {
          rule_id          = "kube-access"
          comment          = "K3s supervisor and Kubernetes API Server"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "443,6443"
          protocol         = "tcp"
          log              = "notice"
          source           = "+k3s-master-list"
        },
        {
          rule_id          = "flannel-master"
          comment          = "Flannel VXLAN master node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "8472,51820,51821"
          protocol         = "udp"
          log              = "nolog"
          source           = "+k3s-master-list"
        },
        {
          rule_id          = "flannel-worker"
          comment          = "Flannel VXLAN worker node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "8472,51820,51821"
          protocol         = "udp"
          log              = "nolog"
          source           = "+k3s-worker-list"
        },
        {
          rule_id          = "monitor-worker"
          comment          = "Kubelet metrics worker node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "10250"
          protocol         = "tcp"
          log              = "nolog"
          source           = "+k3s-worker-list"
        },
        {
          rule_id          = "monitor-master"
          comment          = "Kubelet metrics master node inbound"
          direction        = "in"
          action           = "ACCEPT"
          destination_port = "10250"
          protocol         = "tcp"
          log              = "nolog"
          source           = "+k3s-master-list"
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

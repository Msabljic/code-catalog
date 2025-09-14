variable "base_config" {
  type = object({
    master_nodes       = optional(number, 1)
    master_name_prefix = optional(string, "k3s-master")
    master_cpu_cores   = optional(number, 2)
    master_memory      = optional(number, 4096)
    worker_nodes       = optional(number, 1)
    worker_name_prefix = optional(string, "k3s-worker")
    worker_cpu_cores   = optional(number, 3)
    worker_memory      = optional(number, 1024)
    proxmox_nodes      = list(string)
    network            = optional(string, "vmbr0")
    subnet_range       = string
    gateway            = string
    vm_id              = optional(number, 100)
    mtu                = optional(number, 1500)
    password_length    = optional(number, 16)
    default_username   = optional(string, "k3s-build-admin")
    storage            = optional(string, "lvm")
  })
}

variable "clone" {
  type = object({
    storage      = optional(string, "lvm")
    vm_id        = number
    proxmox_node = string
  })
}

variable "operation" {
  type = object({
    executer_ip = string
  })
}


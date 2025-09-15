# K3S VM Proxmox provisioner
This feature is meant to suppliment techno tim's K3s ansible script which configures k3s. This code will
* Create Virtual machines with minimum user input
* Create username and password for consistent deployment
* Provision firewall rules
* Create Alias of the machines for other fw controls
* Provide a host.ini file of all configured machines

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_local"></a> [local](#requirement\_local) | ~>2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~>3.2 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~>0.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | ~>2.5 |
| <a name="provider_null"></a> [null](#provider\_null) | ~>3.2 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | ~>0.8 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.this](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [proxmox_virtual_environment_firewall_alias.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_alias) | resource |
| [proxmox_virtual_environment_firewall_ipset.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_ipset) | resource |
| [proxmox_virtual_environment_firewall_options.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_options) | resource |
| [proxmox_virtual_environment_firewall_rules.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_firewall_rules) | resource |
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_config"></a> [base\_config](#input\_base\_config) | n/a | <pre>object({<br>    master_nodes       = optional(number, 3)<br>    master_name_prefix = optional(string, "k3s-master")<br>    master_cpu_cores   = optional(number, 1)<br>    master_memory      = optional(number, 4096)<br>    worker_nodes       = optional(number, 3)<br>    worker_name_prefix = optional(string, "k3s-worker")<br>    worker_cpu_cores   = optional(number, 1)<br>    worker_memory      = optional(number, 1024)<br>    proxmox_nodes      = list(string)<br>    network            = optional(string, "vmbr0")<br>    subnet_range       = string<br>    gateway            = string<br>    vm_id              = optional(number, 100)<br>    mtu                = optional(number, 1500)<br>    password_length    = optional(number, 16)<br>    default_username   = optional(string, "k3s-build-admin")<br>    storage            = optional(string, "lvm")<br>    tags               = optional(list(string), [])<br>    started            = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_clone"></a> [clone](#input\_clone) | n/a | <pre>object({<br>    storage      = optional(string, "lvm")<br>    vm_id        = number<br>    proxmox_node = string<br>  })</pre> | n/a | yes |
| <a name="input_operation"></a> [operation](#input\_operation) | n/a | <pre>object({<br>    executer_ip = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~>0.80 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | ~>0.80 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_group.group_identities](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_group) | resource |
| [proxmox_virtual_environment_role.role_creator](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_role) | resource |
| [proxmox_virtual_environment_user.user_identities](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_user) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pamlist"></a> [pamlist](#input\_pamlist) | n/a | <pre>list(object({<br>    group_comment = optional(string, "managed by terraform")<br>    group_name    = string<br>    acls = list(object({<br>      group_path        = optional(string, "/")<br>      group_propagate   = optional(bool, true)<br>      associate_role_id = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_rolelist"></a> [rolelist](#input\_rolelist) | n/a | <pre>list(object({<br>    role_name       = string<br>    role_privileges = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_userlist"></a> [userlist](#input\_userlist) | n/a | <pre>list(object({<br>    user_comment           = optional(string, "managed by terraform")<br>    password               = optional(string, "")<br>    user_id                = string<br>    user_enabled           = optional(bool, true)<br>    user_group_association = list(string)<br>    first_name             = string<br>    last_name              = string<br>    email                  = string<br>    keys                   = optional(string)<br>    expiration_date        = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | n/a |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | n/a |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | n/a |
<!-- END_TF_DOCS -->
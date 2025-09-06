variable "pamlist" {
  type = list(object({
    group_comment = optional(string, "managed by terraform")
    group_name    = string
    acls = list(object({
      group_path        = optional(string, "/")
      group_propagate   = optional(bool, true)
      associate_role_id = string
    }))
  }))
}

variable "userlist" {
  type = list(object({
    user_comment           = optional(string, "managed by terraform")
    password               = optional(string, "")
    user_id                = string
    user_enabled           = optional(bool, true)
    user_group_association = list(string)
    first_name             = string
    last_name              = string
    email                  = string
    keys                   = optional(string)
    expiration_date        = optional(string)
  }))
}

variable "rolelist" {
  type = list(object({
    role_name       = string
    role_privileges = list(string)
  }))
}


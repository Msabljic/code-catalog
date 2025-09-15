terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.8"
    }
    null = {
      source  = "hashicorp/null"
      version = "~>3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"
    }
  }
}
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.83.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
  }
}
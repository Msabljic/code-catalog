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

provider "proxmox" {
  insecure = true
  endpoint = "https://10.230.63.129:8006"
  username = "root@pam"
  password = "mju7mko0MJU&MKO)"
}
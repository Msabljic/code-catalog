base_config = {
  proxmox_nodes = ["prx3", "prx1", "prx2"]
  subnet_range  = "192.168.1.128/28"
  gateway       = "192.168.2.0"
}

clone = {
  vm_id        = 1000
  proxmox_node = "prx1"
}

operation = {
  executer_ip = "192.168.1.100"
}
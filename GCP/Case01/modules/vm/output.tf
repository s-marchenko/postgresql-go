output "vm_ip" {

  value = [for s in google_compute_instance.vm: upper(s.network_interface[0].access_config[0].nat_ip)]
}

//.network_ip
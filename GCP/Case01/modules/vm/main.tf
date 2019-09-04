
resource "google_compute_instance" "vm" {
  name                = "${var.environment}-${var.role}-${count.index}"
  zone                = element(var.zone, count.index)
  deletion_protection = false
  machine_type        = var.machine_type
  count               = var.vm_count
  project             = var.project_name

  boot_disk {
    auto_delete = true

    initialize_params {
      size  = "10"
      type  = "pd-standard"
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    //network = "${google_compute_network.vpc_network.self_link}"

    network = var.network

    access_config {
      // Ephemeral IP  // static IP // nat_ip = "${google_compute_address.static_ip.address}"
    }
  }

  /*------------ User access data--------------------------------*/
  metadata = {
    //ssh-keys = "${var.admin_user}:${tls_private_key.ssh.public_key_openssh}"
  }

  /*------------ Required for firewall settings -----------------*/
  tags = [
    var.environment,
    var.role,
  ]

  /*---------------- User lables --------------------------------*/
  labels = ({
    name        = "${var.environment}-${var.role}",
    environment = var.environment,
    role        = var.role,
  })

}
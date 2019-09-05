# ---------------------------------------------------------------------------------------------------------------------
# CREATE A VM
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_instance" "vm" {
  name                = "${var.environment}-${var.role}-${count.index}-${replace(var.code_version,".","-")}"
  zone                = element(var.zone, count.index)
  deletion_protection = false
  machine_type        = var.machine_type
  count               = var.vm_count
  project             = var.project_name

  lifecycle {
    create_before_destroy = true
  }

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
    ssh-keys = "ubuntu:${file("//Users/sergii.marchenko/.ssh/for-test-servers.pub")}"
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

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A FIREWALL RULES
# ---------------------------------------------------------------------------------------------------------------------

/*------------------- VPC firewall rules -----------------------*/
resource "google_compute_firewall" "firewall_external" {

  /*-------------- Allow external access -------------------------*/
  name     = "${var.environment}-office"
  network  = var.network //google_compute_network.vpc_network.name
  priority = 1100
  project  = var.project_name

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8200", "22", "8080"]
  }

  allow {
    protocol = "udp"
    ports    = ["80", "443", "8200", "22", "8080"]
  }

  source_ranges = ["195.88.124.221/32","82.207.109.122/32","178.151.244.26"]
  target_tags   = [var.environment]

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_firewall" "firewall_internal" {

  /*------------- Allow internal access ---------------------------*/
  name     = "${var.environment}-internal"
  network  = var.network
  priority = 1110
  project  = var.project_name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["10.128.0.0/9"]
  target_tags   = [var.environment]

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A LOAD BALANCER
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_target_pool" "http-lb" {
  name       = "${var.environment}-instance-pool"
  region     = var.region
  project    = var.project_name
  depends_on = [null_resource.startupscript]

  instances = [
    for instance in google_compute_instance.vm: instance.self_link
  ]

  health_checks = [
    google_compute_http_health_check.http-lb-health.name,
  ]
}

resource "google_compute_http_health_check" "http-lb-health" {
  name               = "${var.environment}-http-lb-health"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = 8080
  project            = var.project_name
  depends_on         = [google_compute_instance.vm]
}

resource "google_compute_forwarding_rule" "default" {
  name       = "${var.environment}-load-balancer-${var.region}"
  target     = google_compute_target_pool.http-lb.self_link
  port_range = "8080-8080"
  project    = var.project_name
  depends_on = [google_compute_instance.vm]
}

# ---------------------------------------------------------------------------------------------------------------------
# RUN THE APPLICATION
# ---------------------------------------------------------------------------------------------------------------------

resource "null_resource" "startupscript" {
  count = "${var.vm_count}"
  depends_on = [google_compute_instance.vm]

  triggers = {
    cluster_instance_ids = google_compute_instance.vm[count.index].instance_id
  }

  lifecycle {
    create_before_destroy = true
  }

  connection {
    host = "${element(google_compute_instance.vm[*].network_interface.0.access_config.0.nat_ip, count.index)}"
    type = "ssh"
    user = "ubuntu"
    private_key = file("//Users/sergii.marchenko/.ssh/for-test-servers")
  }

  provisioner "remote-exec" {
    inline = [
      "curl -L https://github.com/s-marchenko/postgresql-go/releases/download/${var.code_version}/website_linux_amd64 --output postg",
      "sudo chmod 755 postg",
      "echo #!/bin/bash > start.sh",
      "echo export DBPORT=5432 >> start.sh",
      "echo export DBHOST=172.28.160.5 >> start.sh",
      "echo export DBUSER=sqladmin >> start.sh",
      "echo export DBPASS=4MQ85I1NHPEt >> start.sh",
      "echo export DBNAME=peopleDatabase >> start.sh",
      "echo './postg' >> start.sh",
      "chmod 755 start.sh",
      "sudo nohup ./start.sh > /dev/null 2>&1 < /dev/null &",
      "sleep 1",
      "echo Finished",
    ]
  }
}
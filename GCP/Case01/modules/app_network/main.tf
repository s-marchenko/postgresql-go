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
  network  = var.network //google_compute_network.vpc_network.name
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
  name   = "instance-pool"
  region = var.region
  project  = var.project_name
  count = var.instances_to_lb == null ? 0: 1

  instances = [
    var.instances_to_lb,
  ]

  health_checks = [
    google_compute_http_health_check.http-lb-health.name,
  ]
}

resource "google_compute_http_health_check" "http-lb-health" {
  name               = "http-lb-health"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port               = 8080
  project  = var.project_name
}

resource "google_compute_forwarding_rule" "default" {
  name       = "load-balancer-${var.region}"
  target     = google_compute_target_pool.http-lb[count.index].self_link
  port_range = "8080-8080"
  project  = var.project_name
  count = var.instances_to_lb == null ? 0: 1
}

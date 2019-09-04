terraform {
  required_version = ">= 0.12, < 0.13"
}
# ---------------------------------------------------------------------------------------------------------------------
# Create a database
# ---------------------------------------------------------------------------------------------------------------------

locals {
  auth_netw_postgres_allowed_1 = [
  for i, addr in ["195.88.124.222", "195.88.124.221"] : {
    name  = "onprem-${i + 1}"
    value = addr
  }
  ]
  auth_netw_postgres_allowed_2 = [
    for i, addr in var.whitelist : {
      name  = "poneip-${i + 1}"
      value = addr
    }
  ]
}

resource "google_sql_database_instance" "sql_instance" {
  name             = "${var.environment}-${random_id.db_name_suffix.hex}"
  region           = var.region
  project          = var.project_name
  database_version = "POSTGRES_9_6"

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled = true

      dynamic "authorized_networks" {
        for_each = concat(
        local.auth_netw_postgres_allowed_1,
        local.auth_netw_postgres_allowed_2,
        )
        iterator = net
        content {
          name  = net.value.name
          value = net.value.value
        }
      }
    }
  }
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database" "database" {
  name             = "peopleDatabase"
  instance         = google_sql_database_instance.sql_instance.name
  project          = var.project_name
  depends_on = [google_sql_database_instance.sql_instance]
}

# ---------------------------------------------------------------------------------------------------------------------
# Create DB Users
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_user" "sqladmin" {
  name             = "sqladmin"
  instance         = google_sql_database_instance.sql_instance.name
  password         = random_string.sqladminpassword.result
  project          = var.project_name
}

resource "random_string" "sqladminpassword" {
  length      = 12
  special     = false
  min_numeric = 4
  min_upper   = 4
}

resource "google_sql_user" "sqluser" {
  name             = "sqluser"
  instance         = google_sql_database_instance.sql_instance.name
  password         = random_string.userpassword.result
  project          = var.project_name
}

resource "random_string" "userpassword" {
  length      = 12
  special     = false
  min_numeric = 4
  min_upper   = 4
}
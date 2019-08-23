terraform {
  required_version = ">= 0.12, < 0.13"
}
# ---------------------------------------------------------------------------------------------------------------------
# Create database
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_database_instance" "sql_instance" {
  name             = "${var.environment}-${random_id.db_name_suffix.hex}"
  region           = var.region
  project          = "learned-acolyte-221721"
  database_version = "POSTGRES_9_6"

  settings {
    tier = var.db_tier

    ip_configuration {
      ipv4_enabled        = true
      //authorized_networks = [{data.null_data_source.auth_net_postgres_allowed.*.outputs}]
      authorized_networks {
          name  = "dev-pro"
          value = "195.88.124.221/32"
//        //data.null_data_source.auth_net_postgres_allowed.[*].outputs
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
  project          = "learned-acolyte-221721"
  depends_on = [google_sql_database_instance.sql_instance]
}

# ---------------------------------------------------------------------------------------------------------------------
# Create DB Users
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_user" "sqladmin" {
  name             = "sqladmin"
  instance         = google_sql_database_instance.sql_instance.name
  password         = random_string.sqladminpassword.result
  project          = "learned-acolyte-221721"
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
  project          = "learned-acolyte-221721"
}

resource "random_string" "userpassword" {
  length      = 12
  special     = false
  min_numeric = 4
  min_upper   = 4
}
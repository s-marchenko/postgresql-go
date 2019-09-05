output "sqladminpassword" {
  value = random_string.sqladminpassword.result
}

output "database_ip" {
  value = google_sql_database_instance.sql_instance.first_ip_address
}

output "database_internal_ip" {
  value = google_sql_database_instance.sql_instance.ip_address
}
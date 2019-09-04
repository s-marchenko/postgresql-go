# ---------------------------------------------------------------------------------------------------------------------
# List of variables you must set
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The type of environmnet which can be dev, stg, prod or other"
}

variable "region" {
  description = "The region when the resource will be created"
}

variable "network" {
  description = "The network name where the resourve will be connected to"
}

variable "whitelist" {
  description = "The list of IPs which have to be whitelisted"
  type = list(string)
}

variable "project_name" {
  description = "The name of GCP progect. Ussually you can get the project name by running the command: gcloud projects list "
  //type = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# List of variables which have defaults
# ---------------------------------------------------------------------------------------------------------------------

variable "db_tier" {
  description = "The database tier"
  default = "db-f1-micro"
}

variable "zone" {
  description = "default zone"
  default     = ["europe-north1-a", "europe-north1-b"]
}

variable "machine_type" {
  description = "VM type"
  default = "g1-small"
}

variable "vm_count" {
  default = "3"
}
variable "role" {
  default = "web"
}

variable "admin_user" {
  default = "admin"
}
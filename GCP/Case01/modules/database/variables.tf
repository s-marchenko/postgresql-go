# ---------------------------------------------------------------------------------------------------------------------
# List of variables you must set
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The type of environmnet which can be dev, stg, prod or other"
}

variable "region" {
  description = "The region when the resource will be created"
}

variable "whitelist" {
  description = "The list of IPs which have to be whitelisted"
  type = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# List of variables which have defaults
# ---------------------------------------------------------------------------------------------------------------------

variable "db_tier" {
  description = "The database tier"
  default = "db-f1-micro"
}
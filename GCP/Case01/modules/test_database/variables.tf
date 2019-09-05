# ---------------------------------------------------------------------------------------------------------------------
# List of variables you must set
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The type of environmnet which can be dev, stg, prod or other"
  //default = "test"
}

variable "region" {
  description = "The region when the resource will be created"
  //default = "europe-north1"
}

variable "path_to_context" {
  description = "The path to your credentials file"
  //default = "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json"
}

variable "whitelist" {
  description = "The list of IPs which have to be whitelisted"
  type = list(string)
  //default = ["178.151.244.26","178.151.244.28"]
}

variable "project_name" {
  description = "The name of GCP progect. Ussually you can get the project name by running the command: gcloud projects list "
  //type = list(string)
}
# ---------------------------------------------------------------------------------------------------------------------
# List of variables which have defaults
# ---------------------------------------------------------------------------------------------------------------------

variable "network" {
  description = "The VPC for the DB"
}
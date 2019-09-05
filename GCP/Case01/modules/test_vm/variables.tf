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

variable "network" {
  description = "The network name where the resourve will be connected to"
}

variable "project_name" {
  description = "The name of GCP progect. Ussually you can get the project name by running the command: gcloud projects list "
  //type = list(string)
}

variable "path_to_context" {
  description = "The path to your credentials file"
  //default = "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json"
}

variable "vm_count" {
  description = "The count of VMs"
  default = "2"
}
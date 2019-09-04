# ---------------------------------------------------------------------------------------------------------------------
# List of variables you must set
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The type of environmnet which can be dev, stg, prod or other"
}

variable "region" {
  description = "The region when the resource will be created"
}

variable "project_name" {
  description = "The name of GCP progect. Ussually you can get the project name by running the command: gcloud projects list "
  //type = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# List of variables which have defaults
# ---------------------------------------------------------------------------------------------------------------------

variable "network" {
  description = "The name of VPN which will be used"
  default = "default"
}

variable "instances_to_lb" {
  description = "The list of instances which have to be added to the load balancer"
  //type        = list(string)
  type        = string
  default     = null
}

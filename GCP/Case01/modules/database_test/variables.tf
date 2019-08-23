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
  default = "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json"
}
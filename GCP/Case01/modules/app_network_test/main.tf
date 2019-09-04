terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "google" {
  credentials	= file("${var.path_to_context}")
  project    	= var.environment
  region     	= var.region
}

terraform {
  backend "gcs" {
    bucket  = "test-tf-state-ie"
    prefix  = "terraform/test/vpc"
    credentials	= "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create a network
# ---------------------------------------------------------------------------------------------------------------------

module "app_network" {
  source = "../app_network"
  environment = var.environment
  region = var.region
  project_name = var.project_name
}
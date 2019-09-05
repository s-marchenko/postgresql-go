terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "google" {
  credentials	= file("${var.path_to_context}")
  project    	= var.project_name
  region     	= var.region
}

terraform {
  backend "gcs" {
    bucket  = "test-tf-state-ie"
    prefix  = "terraform/dev/database"
    credentials	= "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json"
  }
}

module "database" {
  source = "../../modules/database"
  environment = var.environment
  region = var.region
  whitelist = var.whitelist
  project_name = var.project_name
}
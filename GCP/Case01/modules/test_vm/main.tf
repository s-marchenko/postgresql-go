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
    prefix  = "terraform/test/vm"
    credentials	= "/Users/sergii.marchenko/work/keys/gcp/Iegor-072a850167f3.json"
  }
}

module "VM" {
  source = "../vm"
  environment =var.environment
  region = var.region
  project_name = var.project_name
  whitelist = var.whitelist
  network = var.network
  vm_count = var.vm_count
  //path_to_context = var.path_to_context
}
terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    credentials = "./terraform-sa-keyfile.json"
    bucket      = "terraform-remote-state-ingcogito"
    prefix      = "terraform/state"
  }
}

provider "google" {
  project     = var.project_name
  credentials = file("terraform-sa-keyfile.json")
  region      = var.region
  zone        = var.zone
  version     = "~> 3.18"
}

provider "google-beta" {
  project     = var.project_name
  credentials = file("terraform-sa-keyfile.json")
  region      = var.region
  zone        = var.zone
  version     = "~> 3.18"
}


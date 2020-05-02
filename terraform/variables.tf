// Configure the Google Cloud provider

variable "project_name" {
  type = string
}

variable "gcp_credentials_path" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_pub_key_path" {
  type = string
}

variable "app_name" {
  type = string
}

variable "private_subnet_cidr_1" {
  type = string
}

variable "image_name" {
  type = string
}

variable "swarm_workers" {
  default = 1
}

variable "swarm_workers_instance_type" {
  type = string
}

variable "managers_image_size" {
  default = 20
}

variable "swarm_managers_instance_type" {
  type = string
}

variable "workers_image_size" {
  default = 10
}

variable "lb_static_ip" {
  description = "loadbalancer static ip"
}

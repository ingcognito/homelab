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

# Cloud SQL Variables
variable "sql_instance_size" {
  description = "Size of Cloud SQL instances"
}

variable "sql_disk_type" {
  description = "Cloud SQL instance disk type"
}

variable "sql_disk_size" {
  description = "Storage size in GB"
  default     = 10
}

variable "sql_require_ssl" {
  description = "Enforce SSL connections"
}

variable "sql_connect_retry_interval" {
  description = "The number of seconds between connect retries."
}

variable "sql_master_zone" {
  description = "Zone of the Cloud SQL master (a, b, ...)"
}

variable "sql_replica_zone" {
  description = "Zone of the Cloud SQL replica (a, b, ...)"
}

variable "sql_user" {
  description = "Username of the host to access the database"
}

variable "sql_pass" {
  description = "Password of the host to access the database"
}

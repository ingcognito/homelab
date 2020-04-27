// ######################## Postgres Setup
#######################################################################################

//provider "random" {}
//
//resource "random_id" "id" {
//  byte_length = 4
//  prefix      = "supermagicdiary-psql-"
//}
//
//resource "google_sql_database_instance" "master" {
//  name             = "${random_id.id.hex}"
//  region           = "${var.region}"
//  database_version = "POSTGRES_11"
//
//  settings {
//    tier              = "${var.sql_instance_size}"
//    disk_type         = "${var.sql_disk_type}"
//    disk_size         = "${var.sql_disk_size}"
//    disk_autoresize   = true
//
//    ip_configuration {
//      require_ssl  = "${var.sql_require_ssl}"
//      ipv4_enabled = true
//    }
//
//    location_preference {
//      zone = "${var.sql_master_zone}"
//    }
//
//    backup_configuration {
//#      binary_log_enabled = true
//      enabled            = true
//      start_time         = "00:00"
//    }
//  }
//}
//
//resource "google_sql_database_instance" "replica" {
//  depends_on = [
//    "google_sql_database_instance.master",
//  ]
//
//  name                 = "supermagicdiary-psql-replica"
//  count                = 1
//  region               = "${var.region}"
//  database_version     = "POSTGRES_11"
//  master_instance_name = "${google_sql_database_instance.master.name}"
//
//  settings {
//    tier            = "${var.sql_instance_size}"
//    disk_type       = "${var.sql_disk_type}"
//    disk_size       = "${var.sql_disk_size}"
//    disk_autoresize = true
//
//    location_preference {
//      zone = "${var.sql_replica_zone}"
//    }
//  }
//}
//
//resource "google_sql_user" "user" {
//  depends_on = [
//    "google_sql_database_instance.master",
//    "google_sql_database_instance.replica",
//  ]
//
//  instance = "${google_sql_database_instance.master.name}"
//  name     = "${var.sql_user}"
//  password = "${var.sql_pass}"
//}
//
//resource "google_sql_database" "database" {
//  name     = "production"
//  instance = google_sql_database_instance.master.name
//}

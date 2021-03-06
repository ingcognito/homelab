# creates a group of dissimilar virtual machine instances
resource "google_compute_instance_group" "web_private_group" {
  name        = "${var.app_name}-vm-group"
  description = "Web servers instance group"
  zone        = var.zone

  instances = [
    google_compute_instance.managers[0].self_link,
    google_compute_instance.workers[0].self_link,
  ]

  named_port {
    name = "tcp8080"
    port = "8080"
  }

  named_port {
    name = "tcp1337"
    port = "1337"
  }

  named_port {
    name = "tcp6969"
    port = "6969"
  }

  named_port {
    name = "tcp9001"
    port = "9001"
  }
}

resource "google_compute_backend_service" "backend_service_production" {
  name          = "${var.app_name}-production"
  project       = "${var.project_name}"
  port_name     = "tcp1337"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck_production.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_health_check" "healthcheck_production" {
  name                = "tcp1337-healthcheck"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 4
  unhealthy_threshold = 5
  tcp_health_check {
    port = 1337
  }
}

resource "google_compute_backend_service" "backend_service_staging" {
  name          = "${var.app_name}-staging"
  project       = "${var.project_name}"
  port_name     = "tcp6969"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck_staging.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_health_check" "healthcheck_staging" {
  name                = "tcp6969-healthcheck"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 4
  unhealthy_threshold = 5
  tcp_health_check {
    port = 6969
  }
}


resource "google_compute_backend_service" "backend_service_develop" {
  name          = "${var.app_name}-develop"
  project       = "${var.project_name}"
  port_name     = "tcp9001"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck_develop.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_health_check" "healthcheck_develop" {
  name                = "tcp9001-healthcheck"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 4
  unhealthy_threshold = 5
  tcp_health_check {
    port = 9001
  }
}


resource "google_compute_backend_service" "backend_service_jenkins" {
  name          = "${var.app_name}-jenkins"
  project       = "${var.project_name}"
  port_name     = "tcp8080"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck_jenkins.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_health_check" "healthcheck_jenkins" {
  name                = "tcp8080-healthcheck"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 4
  unhealthy_threshold = 5
  tcp_health_check {
    port = 8080
  }
}

resource "google_compute_backend_bucket" "ensemblecanada" {
  name        = "backend-bucket-ensemblecanada"
  bucket_name = google_storage_bucket.static_site_ensemblecanada.name
  enable_cdn  = true
}

resource "google_compute_backend_bucket" "noahing" {
  name        = "backend-bucket-noahing"
  bucket_name = google_storage_bucket.static_site_noahing.name
  enable_cdn  = true
}

resource "google_compute_backend_bucket" "ingcognito" {
  name        = "backend-bucket-ingcognito"
  bucket_name = google_storage_bucket.static_site_ingcognito.name
  enable_cdn  = true
}



resource "google_compute_url_map" "url_map" {
  name            = "${var.app_name}-load-balancer"
  project         = var.project_name
  default_service = google_compute_backend_bucket.noahing.self_link

  host_rule {
    hosts        = ["ingcognito.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.ingcognito.self_link
  }

  host_rule {
    hosts        = ["ensemblecanada.com"]
    path_matcher = "ensemble"
  }
  path_matcher {
    name            = "ensemble"
    default_service = google_compute_backend_bucket.ensemblecanada.self_link
  }

  host_rule {
    hosts        = ["noahing.com"]
    path_matcher = "noahing"
  }
  path_matcher {
    name            = "noahing"
    default_service = google_compute_backend_bucket.noahing.self_link
  }

  host_rule {
    hosts        = ["jenkins.ingcognito.com"]
    path_matcher = "jenkins"
  }
  path_matcher {
    name            = "jenkins"
    default_service = google_compute_backend_service.backend_service_jenkins.self_link
  }

  host_rule {
    hosts        = ["supermagicdiary.com"]
    path_matcher = "production"
  }
  path_matcher {
    name            = "production"
    default_service = google_compute_backend_service.backend_service_production.self_link
  }

  host_rule {
    hosts        = ["staging.supermagicdiary.com"]
    path_matcher = "staging"
  }
  path_matcher {
    name            = "staging"
    default_service = google_compute_backend_service.backend_service_staging.self_link
  }

  host_rule {
    hosts        = ["develop.supermagicdiary.com"]
    path_matcher = "develop"
  }
  path_matcher {
    name            = "develop"
    default_service = google_compute_backend_service.backend_service_develop.self_link
  }
}

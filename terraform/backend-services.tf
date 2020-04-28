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
}


resource "google_compute_backend_service" "backend_service_jenkins" {
  name          = "${var.app_name}-develop"
  project       = "${var.project_name}"
  port_name     = "tcp8080"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck_develop.self_link}"]

  backend {
    group                 = google_compute_instance_group.web_private_group.self_link
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_health_check" "healthcheck_develop" {
  name                = "tcp8080-healthcheck"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 4
  unhealthy_threshold = 5
  tcp_health_check {
    port = 8080
  }
}
# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name            = "${var.app_name}-load-balancer"
  project         = var.project_name
  default_service = google_compute_backend_service.backend_service_jenkins.self_link
  host_rule {
    hosts        = ["ingcognito.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend_service_jenkins.self_link
  }

  host_rule {
    hosts        = ["jenkins.ingcognito.com"]
    path_matcher = "jenkins"
  }
  path_matcher {
    name            = "jenkins"
    default_service = google_compute_backend_service.backend_service_jenkins.self_link
  }
}

// ######################## Load balancer
#######################################################################################

resource "google_compute_global_address" "lb_static_ip" {
  name = "global-loadbalancer-ip"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_http" {
  name       = "${var.app_name}-global-forwarding-rule-http"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  ip_address = "35.201.79.174"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name        = "target-proxy"
  description = "a description"
  url_map     = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_https" {
  name       = "${var.app_name}-global-forwarding-rule"
  project    = var.project_name
  target     = google_compute_target_https_proxy.https_proxy.self_link
  ip_address = "35.201.79.174"
  port_range = "443"
}

resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  provider = google-beta
  name     = "supermagicdiary"

  managed {
    domains = ["supermagicdiary.com"]
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  provider = google-beta

  name             = "${var.app_name}-https-proxy"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.self_link]
}

# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
#resource "google_compute_target_http_proxy" "target_http_proxy" {
#  name    = "${var.app_name}-http-proxy"
#  project = var.project_name
#  url_map = google_compute_url_map.url_map.self_link
#}

# creates a group of dissimilar virtual machine instances
resource "google_compute_instance_group" "web_private_group" {
  name        = "${var.app_name}-vm-group"
  description = "Web servers instance group"
  zone        = var.zone

  instances = [
    google_compute_instance.managers[0].self_link,
    google_compute_instance.workers[0].self_link,
    google_compute_instance.workers[1].self_link
  ]

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
  name                = "tcp8008-healthcheck"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 4
  unhealthy_threshold = 5
  tcp_health_check {
    port = 9001
  }
}
# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name            = "${var.app_name}-load-balancer"
  project         = var.project_name
  default_service = google_compute_backend_service.backend_service_production.self_link
  host_rule {
    hosts        = ["supermagicdiary.com"]
    path_matcher = "allpaths"
  }
  path_matcher {
    name            = "allpaths"
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
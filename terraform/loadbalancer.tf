// ######################## Load balancer
#######################################################################################

resource "google_compute_global_address" "lb_static_ip" {
  name = "global-loadbalancer-ip"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_http" {
  name       = "${var.app_name}-global-forwarding-rule-http"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  ip_address = var.lb_static_ip
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
  ip_address = var.lb_static_ip
  port_range = "443"
}

resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  provider = google-beta
  name     = "ingcognito"

  managed {
    domains = ["ingcognito.com"]
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  provider = google-beta

  name             = "${var.app_name}-https-proxy"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.self_link]
}


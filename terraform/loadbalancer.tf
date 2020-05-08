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

// ######################## supermagicdiary
#######################################################################################

resource "google_compute_global_address" "lb_static_ip_supermagicdiary" {
  name = "global-loadbalancer-ip-supermagicdiary"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_http_smd" {
  name       = "${var.app_name}-global-forwarding-rule-http-smd"
  target     = google_compute_target_http_proxy.http_proxy_smd.self_link
  ip_address = google_compute_global_address.lb_static_ip_supermagicdiary.address
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http_proxy_smd" {
  name        = "target-proxy-smd"
  description = "a description"
  url_map     = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_https_smd" {
  name       = "${var.app_name}-global-forwarding-rule-smd"
  project    = var.project_name
  target     = google_compute_target_https_proxy.https_proxy_smd.self_link
  ip_address = google_compute_global_address.lb_static_ip_supermagicdiary.address
  port_range = "443"
}

resource "google_compute_managed_ssl_certificate" "ssl_certificate_smd" {
  provider = google-beta
  name     = "supermagicdiary"

  managed {
    domains = ["supermagicdiary.com"]
  }
}

resource "google_compute_target_https_proxy" "https_proxy_smd" {
  provider = google-beta

  name             = "${var.app_name}-https-proxy-smd"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate_smd.self_link]
}

// ######################## noahing
#######################################################################################

resource "google_compute_global_address" "lb_static_ip_noahing" {
  name = "global-loadbalancer-ip-noahing"
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_http_noahing" {
  name       = "${var.app_name}-global-forwarding-rule-http-noahing"
  target     = google_compute_target_http_proxy.http_proxy_noahing.self_link
  ip_address = google_compute_global_address.lb_static_ip_noahing.address
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http_proxy_noahing" {
  name        = "target-proxy-noahing"
  description = "a description"
  url_map     = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule_https_noahing" {
  name       = "${var.app_name}-global-forwarding-rule-noahing"
  project    = var.project_name
  target     = google_compute_target_https_proxy.https_proxy_noahing.self_link
  ip_address = google_compute_global_address.lb_static_ip_noahing.address
  port_range = "443"
}

resource "google_compute_managed_ssl_certificate" "ssl_certificate_noahing" {
  provider = google-beta
  name     = "noahing"

  managed {
    domains = ["noahing.com"]
  }
}

resource "google_compute_target_https_proxy" "https_proxy_noahing" {
  provider = google-beta

  name             = "${var.app_name}-https-proxy-noahing"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate_noahing.self_link]
}

// ######################## Network
#######################################################################################

resource "google_compute_network" "vpc" {
  name                    = "${var.app_name}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "private_subnet" {
  provider      = "google-beta"
  purpose       = "PRIVATE"
  project       = var.project_name
  name          = "${var.app_name}-private-subnet"
  ip_cidr_range = var.private_subnet_cidr_1
  network       = google_compute_network.vpc.name
  region        = var.region
}

resource "google_compute_address" "nat_ip" {
  name   = "${var.app_name}-nat-ip"
  region = var.region
}

resource "google_compute_router" "nat-router" {
  name    = "${var.app_name}-nat-router"
  network = google_compute_network.vpc.name
}

resource "google_compute_router_nat" "nat-gateway" {
  name                               = "${var.app_name}-nat-gateway"
  router                             = google_compute_router.nat-router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat_ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.nat_ip]
}

# allow internal icmp
resource "google_compute_firewall" "allow-internal" {
  name    = "${var.app_name}-fw-allow-internal"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.private_subnet_cidr_1}"
  ]
}

resource "google_compute_firewall" "allow-http" {
  name    = "${var.app_name}-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

# allow https
resource "google_compute_firewall" "allow-https" {
  name    = "${var.app_name}-fw-allow-https"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.app_name}-fw-allow-ssh"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

# docker port
resource "google_compute_firewall" "allow-docker" {
  name    = "${var.app_name}-fw-allow-docker"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["2376", "2377", "7946", "8080"]
  }
  allow {
    protocol = "udp"
    ports    = ["4789", "7946"]
  }
  target_tags = ["docker"]
}

// ######################## Docker Swarm Setup
#######################################################################################
resource "google_compute_address" "static_manager" {
  name = "ipv4-address-manager"
}

resource "google_compute_address" "static" {
  count = "${var.swarm_workers}"
  name  = "ipv4-address${count.index + 1}"
}

resource "google_compute_instance" "managers" {
  name         = "managers"
  count        = 1
  machine_type = "${var.swarm_managers_instance_type}"
  zone         = "${var.zone}"
  tags         = ["ssh", "http", "https", "docker"]

  boot_disk {
    initialize_params {
      image = "${var.image_name}"
      size  = "${var.managers_image_size}"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }

  network_interface {
    network    = "${google_compute_network.vpc.name}"
    subnetwork = "${google_compute_subnetwork.private_subnet.name}"
    access_config {
      nat_ip = "${google_compute_address.static_manager.address}"
    }
  }
}

resource "google_compute_instance" "workers" {
  count        = "${var.swarm_workers}"
  name         = "worker${count.index + 1}"
  machine_type = "${var.swarm_workers_instance_type}"
  zone         = "${var.zone}"
  tags         = ["ssh", "http", "https", "docker"]

  depends_on = ["google_compute_instance.managers"]

  boot_disk {
    initialize_params {
      image = "${var.image_name}"
      size  = "${var.workers_image_size}"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }

  network_interface {
    network    = "${google_compute_network.vpc.name}"
    subnetwork = "${google_compute_subnetwork.private_subnet.name}"
    access_config {
      nat_ip = "${google_compute_address.static[count.index].address}"
    }
  }
}

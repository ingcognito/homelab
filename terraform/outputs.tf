output "Swarm_manager_IPs" {
  value = "${google_compute_instance.managers.*.network_interface.0.access_config.0.nat_ip}"
}

output "Swarm_workers_IPs" {
  value = "${google_compute_instance.workers.*.network_interface.0.access_config.0.nat_ip}"
}

output "loadbalancer_ip" {
  value = google_compute_global_address.lb_static_ip.address
}

output "loadbalancer_ip_supermagicdiary" {
  value = google_compute_global_address.lb_static_ip_supermagicdiary.address
}

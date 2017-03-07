resource "google_compute_network" "phgoub.cr460lab.com" {
  name                    = "phgoub.cr460lab.com"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "east1-dmz" {
  name          = "east1-dmz"
  ip_cidr_range = "172.16.1.0/24"
  network       = "${google_compute_network.phgoub.cr460lab.com.self_link}"
  region        = "us-east1"
}

resource "google_compute_subnetwork" "east1-internal" {
  name          = "east1-internal"
  ip_cidr_range = "10.0.1.0/24"
  network       = "${google_compute_network.phgoub.cr460lab.com.self_link}"
  region        = "us-east1"
}

resource "google_compute_firewall" "web" {
  name    = "web"
  network = "${google_compute_network.phgoub.cr460lab.com.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = "${google_compute_network.phgoub.cr460lab.com.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}

resource "google_dns_record_set" "www" {
  name = "www. phgoub.cr460lab.com.com."
  type = "A"
  ttl  = 300

  managed_zone = "phgoub"

  rrdatas = ["${google_compute_instance.instance1.network_interface.0.access_config.0.assigned_nat_ip}"]
}

provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "shimizu-test-20200202"
  region      = "asia-northeast1"
  zone        = "asia-northeast1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_address" "vm_tatic_ip" {
  name = "terraform-static-ip"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.vm_tatic_ip.address
    }
  }
}

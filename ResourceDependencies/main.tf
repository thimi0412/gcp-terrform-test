provider "google" {
  credentials = "../credentials.json"
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

resource "google_storage_bucket" "example_bucket" {
  name     = "terraform-example-bucket-shimizh-20200202"
  location = "ASIA"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "another_instance" {
  depends_on = [google_storage_bucket.example_bucket]

  name         = "terraform-instance-2"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

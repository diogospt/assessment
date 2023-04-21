resource "google_compute_subnetwork" "ew4-kubernetes" {
  name          = var.vpc_subnetwork
  ip_cidr_range = "10.240.0.0/24"
  region        = "europe-west4"
  network       = google_compute_network.kubernetes.id
  project       = var.project_id
}

resource "google_compute_network" "kubernetes" {
  project                 = var.project_id
  name                    = "kubernetes"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_firewall" "allow_internal" {
  name    = "kubernetes-allow-internal"
  network = google_compute_network.kubernetes.name
  project = var.project_id
  direction = "INGRESS"
  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_external" {
  name    = "kubernetes-allow-external"
  network = google_compute_network.kubernetes.name
  project = var.project_id
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports = ["22", "6443"]
  }

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_address" "static-kubernetes" {
  project = var.project_id
  name = "kubernetes-public-ip"
  region = "europe-west4"
}


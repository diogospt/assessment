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

resource "google_compute_firewall" "kubernetes-allow-health-check" {
  name = "kubernetes-allow-health-check"
  network = google_compute_network.kubernetes.name
  project = var.project_id
  direction = "INGRESS"
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  allow {
    protocol = "tcp"
  }
}

resource "google_compute_target_pool" "kubernetes-target-pool" {
  name = "kubernetes-target-pool"

  instances = [
    "europe-west4-a/master-0",
    "europe-west4-b/master-1",
  ]

  health_checks = [
    google_compute_http_health_check.kubernetes-health-check.name,
  ]
}

resource "google_compute_http_health_check" "kubernetes-health-check" {
  description = "Kubernetes Health Check"
  name = "kubernetes-health-check"
  host = "kubernetes.default.svc.cluster.local"
  request_path = "/healthz"
}

resource "google_compute_forwarding_rule" "kubernetes-forwarding-rule" {
  ip_address = google_compute_address.static-kubernetes.address
  port_range = "6443"
  project = var.project_id
  name = "kubernetes-forwarding-rule"
  region = "europe-west4"
  target = google_compute_target_pool.kubernetes-target-pool.id
}


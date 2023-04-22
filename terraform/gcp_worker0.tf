resource "google_compute_instance" "worker-0" {
  name                      = "worker-0"
  machine_type              = "custom-2-2048"
  allow_stopping_for_update = "false"
  zone                      = var.zone_a
  project                   = var.project_id

  boot_disk {
    source      = google_compute_disk.worker-0-boot-disk.id
    auto_delete = true
  }

  tags = ["master", "kubernetes"]
  can_ip_forward = "true"

  network_interface {
    subnetwork = var.vpc_subnetwork
    subnetwork_project = var.project_id
    network_ip = google_compute_address.address-worker-0.address

    access_config {}
  }

  service_account {
    scopes =  ["compute-rw" ,"storage-ro" ,"service-management", "service-control", "logging-write", "monitoring"]
  }

}

resource "google_compute_address" "address-worker-0" {
  name = "worker-0"
  address_type = "INTERNAL"
  subnetwork = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/regions/europe-west4/subnetworks/${var.vpc_subnetwork}"
  project = var.project_id
  prefix_length = "0"
  region = var.region
  address = "10.240.0.20"
}

resource "google_compute_disk" "worker-0-boot-disk" {
  name  = "boot-disk-worker-0"
  image = "debian-11-bullseye-v20230411"
  type  = "pd-standard"
  size  = "30"
  zone  = var.zone_a
  project = var.project_id
}
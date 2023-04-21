# Create project
resource "google_project" "infrastructure" {
  name       = "infrastructure"
  project_id = var.project_id
  billing_account = "01C3BF-2B19C2-A740CC"
}

# Enable Compute API
resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
}

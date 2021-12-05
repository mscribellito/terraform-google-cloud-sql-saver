# Enable APIs
resource "google_project_service" "enable_services" {
  project                    = var.project_id
  for_each                   = toset(var.gcp_services)
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = false
}

# Wait for above APIs to be enabled before creating function & jobs
resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"

  depends_on = [
    google_project_service.enable_services
  ]
}

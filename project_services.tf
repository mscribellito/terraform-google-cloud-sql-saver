# Enable APIs

locals {
  gcp_services = [
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com", # Required for using Cloud Scheduler
    "sqladmin.googleapis.com"        # Required for starting/stopping Cloud SQL instances
  ]
}

resource "google_project_service" "enable_services" {
  project                    = var.project_id
  count                      = length(local.gcp_services)
  service                    = local.gcp_services[count.index]
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

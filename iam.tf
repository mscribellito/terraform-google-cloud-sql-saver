resource "google_service_account" "service_account" {
  project    = var.project_id
  account_id = local.base_name
}

# https://cloud.google.com/sql/docs/mysql/project-access-control#permissions-gcloud
# Role with permissions for `gcloud sql instances patch`
resource "google_project_iam_custom_role" "role_cloudsql_patch" {
  project     = var.project_id
  role_id     = "cloudsql.instancePatcher"
  title       = "Cloud SQL Instance Patcher"
  description = "Patch existing Cloud SQL instances"
  permissions = ["cloudsql.instances.get", "cloudsql.instances.update"]
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = google_project_iam_custom_role.role_cloudsql_patch.id
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

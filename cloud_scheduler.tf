# Enable app engine
resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.region
  count       = var.create_app_engine ? 1 : 0
}

# Start & stop scheduled jobs
resource "google_cloud_scheduler_job" "start_job" {
  project     = var.project_id
  region      = var.region
  for_each    = { for job in var.start_jobs : job.name => job }
  name        = "${local.base_name}-${each.value.name}-start"
  description = "Start Cloud SQL instances"
  schedule    = each.value.schedule
  time_zone   = coalesce(each.value.time_zone, var.time_zone)

  pubsub_target {
    topic_name = google_pubsub_topic.instance_mgmt.id
    data = base64encode(jsonencode({
      Instances = each.value.instances
      Project   = var.project_id
      Action    = "start"
    }))
  }

  depends_on = [
    google_app_engine_application.app,
    time_sleep.wait_30_seconds
  ]
}

resource "google_cloud_scheduler_job" "stop_job" {
  project     = var.project_id
  region      = var.region
  for_each    = { for job in var.stop_jobs : job.name => job }
  name        = "${local.base_name}-${each.value.name}-stop"
  description = "Stop Cloud SQL instances"
  schedule    = each.value.schedule
  time_zone   = coalesce(each.value.time_zone, var.time_zone)

  pubsub_target {
    topic_name = google_pubsub_topic.instance_mgmt.id
    data = base64encode(jsonencode({
      Instances = each.value.instances
      Project   = var.project_id
      Action    = "stop"
    }))
  }

  depends_on = [
    google_app_engine_application.app,
    time_sleep.wait_30_seconds
  ]
}
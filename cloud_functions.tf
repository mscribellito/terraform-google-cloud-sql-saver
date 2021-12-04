# Create archive of source and store in /tmp
data "archive_file" "source" {
  type        = "zip"
  source_dir  = abspath("${path.module}/function")
  output_path = "${path.module}/${local.base_name}-function.zip"
}

# Create the start/stop function
resource "google_cloudfunctions_function" "start_stop" {
  project     = var.project_id
  region      = var.region
  name        = "${local.base_name}-start-stop"
  description = "Start or Stop Cloud SQL instances"
  runtime     = "go116"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.source.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = "ProcessPubSub"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.instance_mgmt.id
  }

  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

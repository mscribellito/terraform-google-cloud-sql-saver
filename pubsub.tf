# Create Pub/Sub topic for start/stop events
resource "google_pubsub_topic" "instance_mgmt" {
  project = var.project_id
  name    = "${local.base_name}-instance-mgmt"
}

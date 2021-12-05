locals {
  job_actions = ["start", "stop"]

  /**Just some magic to create a nested loop 
  Example input:
   {
    "8am-5pm" = {
      start     = "0 8 * * 1-5"
      stop      = "0 17 * * 1-5"
      instances = ["acme-db"]
      time_zone = null
    }
  }
  Example output:
  {
    "8am-5pm_start" = {
      "action" = "start"
      "instances" = [
        "acme-db",
      ]
      "schedule" = "0 8 * * 1-5"
      "time_zone" = null
    }
    "8am-5pm_stop" = {
      "action" = "stop"
      "instances" = [
        "acme-db",
      ]
      "schedule" = "0 17 * * 1-5"
      "time_zone" = null
    }
  }
**/
  jobs = values({ for k, v in var.jobs : k => { for x in local.job_actions :
    "${k}_${x}" => merge({ for o, p in v : o => p if !contains(local.job_actions, o) }, { schedule : v[x], action : x }) if contains(keys(v), x)
  } })[0]
}

# Enable app engine
resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.region
  count       = var.create_app_engine ? 1 : 0
}

# Start & stop scheduled jobs
resource "google_cloud_scheduler_job" "job" {
  project     = var.project_id
  region      = var.region
  for_each    = local.jobs
  name        = "${local.base_name}-${each.key}"
  description = "Stop Cloud SQL instances"
  schedule    = each.value.schedule
  time_zone   = lookup(each.value, "time_zone", var.time_zone)

  pubsub_target {
    topic_name = google_pubsub_topic.instance_mgmt.id
    data = base64encode(jsonencode({
      Instances = each.value.instances
      Project   = var.project_id
      Action    = each.value.action
    }))
  }

  depends_on = [
    google_app_engine_application.app,
    time_sleep.wait_30_seconds
  ]
}
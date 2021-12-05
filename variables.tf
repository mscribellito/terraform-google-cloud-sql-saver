variable "project_id" {
  type        = string
  description = "The project ID to manage the resources."
}

variable "region" {
  type        = string
  description = "The region of the resources."
  default     = "us-east1"
}

variable "jobs" {
  type        = map(object({ start = string, stop = string, instances = list(string), time_zone = string }))
  description = "Map of job config."
  default     = {}
}

variable "time_zone" {
  type        = string
  description = "Default time zone name from the tz database for scheduled jobs."
  default     = "America/New_York"
}

variable "create_app_engine" {
  type        = bool
  description = "Whether App Engine application should be created."
  default     = true
}

variable "gcp_services" {
  type        = list(string)
  description = "List of GCP Services to enable."
  default = [
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com", # Required for using Cloud Scheduler
    "sqladmin.googleapis.com"        # Required for starting/stopping Cloud SQL instances
  ]
}
variable "project_id" {
  type        = string
  description = "The project ID to manage the resources."
}

variable "region" {
  type        = string
  description = "The region of the resources."
  default     = "us-east1"
}

variable "time_zone" {
  type        = string
  description = "Default time zone name from the tz database for scheduled jobs."
  default     = "America/New_York"
}

variable "start_jobs" {
  type = list(object({
    name      = string
    schedule  = string
    instances = list(string)
    time_zone = string
  }))
  description = "List of start jobs."
  default     = []
}

variable "stop_jobs" {
  type = list(object({
    name      = string
    schedule  = string
    instances = list(string)
    time_zone = string
  }))
  description = "List of stop jobs."
  default     = []
}

variable "create_app_engine" {
  type        = bool
  description = "Whether App Engine application should be created."
  default     = true
}
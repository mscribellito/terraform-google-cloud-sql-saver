# terraform-google-cloud-sql-saver
Terraform module to simplify cost savings of Cloud SQL instances on GCP.

[View on Terraform Registry](https://registry.terraform.io/modules/mscribellito/cloud-sql-saver/google/latest)

## Purpose

This module is intended to reduce the cost of using GCP's Cloud SQL service by scheduling your instances to start and stop. This is a practice that would typically be implemented in a non-production environment. Running your instances in this manner can save you ~75% of the cost to run an instance per week. The cost savings estimate assumes an instance running 9 hours a day, 5 days a week compared to 24/7.

**Note: Backups can only be performed while an instance is running so the backup window needs to be adjusted accordingly.**

Inspired by a [blog post](https://cloud.google.com/blog/topics/developers-practitioners/lower-development-costs-schedule-cloud-sql-instances-start-and-stop) from Google, the module was developed with reusability in mind by leveraging [Terraform](https://www.terraform.io/). It also goes a step beyond that of the blog post to handle:

* Multiple start/stop schedules
* Multiple instances

### Architecture

![Cloud SQL Saver architecture](https://github.com/mscribellito/terraform-google-cloud-sql-saver/blob/main/architecture.png?raw=true)

1. Cloud Scheduler job sends start/stop message to Pub/Sub topic.
2. Pub/Sub topic message publish event triggers the Cloud Function.
3. Cloud Function sends start/stop API call to Cloud SQL instance(s).

## Requirements

* [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
* [terraform-provider-google](https://registry.terraform.io/providers/hashicorp/google/4.2.0) plugin v4.2.x

## Usage

```hcl
module "cloud-sql-saver" {
  source     = "mscribellito/cloud-sql-saver/google"
  project_id = "your-project-id"
  region     = "us-east1"
  schedule =  {
    "8am-5pm" = {
      start     = "0 8 * * 1-5"
      stop      = "0 17 * * 1-5"
      instances = ["acme-db-1", "acme-db-2"]
      time_zone = null
    }
    "10am-3pm" = {
      start     = "0 10 * * 6-7"
      stop      = "0 15 * * 6-7"
      instances = ["acme-db-3", "acme-db-4"]
      time_zone = null
    }
  }
  create_app_engine = false # set to false if an App Engine application is already created in your project
}
```

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | -------- |
| project_id | The project ID to manage the resources. | `string` | n/a | yes
| region | The region of the resources. | `string` | `"us-east1"` | no
| schedule | Start/stop schedule. | `map(object({ start = string, stop = string, instances = list(string), time_zone = string }))` | `{}` | no
| time_zone | Default time zone name from the tz database for scheduled jobs. | `string` | `"America/New_York"` | no
| create_app_engine | Whether App Engine application should be created. | `bool` | `true` | no
| gcp_services | List of GCP Services to enable. | `list(string)` | See `variables.tf` | no


## Outputs

N/A

## Changelog
  
* **1.1.0**
  * Add least privilege service account for Cloud Function.

* **1.0.0**
  * Release stable version.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
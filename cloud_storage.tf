# Create bucket for hosting the source
resource "google_storage_bucket" "source" {
  project  = var.project_id
  name     = "${local.base_name}-source"
  location = var.region
}

# Create object containing the source
resource "google_storage_bucket_object" "archive" {
  name   = "source.zip"
  source = data.archive_file.source.output_path
  bucket = google_storage_bucket.source.name
}

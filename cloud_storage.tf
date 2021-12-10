resource "random_pet" "random_pet" {
  length = 16
}

# Create bucket for hosting the source
resource "google_storage_bucket" "source" {
  project = var.project_id
  # Attempt to create unique bucket name
  name     = substr("${local.base_name}-source-${sha256(join("", [random_pet.random_pet.id, var.project_id]))}", 0, 63)
  location = var.region
}

# Create object containing the source
resource "google_storage_bucket_object" "archive" {
  name   = "source.zip"
  source = data.archive_file.source.output_path
  bucket = google_storage_bucket.source.name
}

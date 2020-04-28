resource "google_storage_bucket" "static-site-noahing" {
  name          = "noahing-com"
  location      = "US"
  force_destroy = true

  bucket_policy_only = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static-site-noahing.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket" "static-site-ensemblecanada" {
  name          = "ensemblecanada-com"
  location      = "US"
  force_destroy = true

  bucket_policy_only = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static-site-ensemblecanada.name
  role   = "READER"
  entity = "allUsers"
}

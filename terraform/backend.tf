terraform {
  backend "gcs" {
    bucket = "github-reports"
    prefix = "terraform/state"
  }
} 

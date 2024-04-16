provider "google" {
  project     = "test-project-miguel"
  region      = "us-central1"
}

data "google_sourcerepo_repository" "github_mirror" {
  name = "github_miguelortize_github-weekly-report"
}

resource "google_cloudfunctions_function" "pull_request_summary" {
  name        = "pull-request-summary"
  description = "Summarizes pull requests for a given GitHub repository."
  runtime     = "python312"

  available_memory_mb   = 256
  source_repository {
    url = data.google_sourcerepo_repository.github_mirror.url
  }
  entry_point       = "pull_requests_summary"
  trigger_http      = true

  environment_variables = {
    GITHUB_TOKEN = "<YOUR-GITHUB-TOKEN>"
    EMAIL_FROM   = "notifications@example.com"
    EMAIL_TO     = "developer@example.com"
  }

  timeouts {
    create = "60s"
    update = "60s"
    delete = "60s"
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_project_iam_member" "secret_accessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${var.service_account}"
}


resource "google_cloudfunctions_function" "pull_request_summary" {
  depends_on  = [google_project_iam_member.secret_accessor]
  name        = var.cloud_function_name
  description = "Summarizes pull requests for a given GitHub repository."
  runtime     = "python312"

  available_memory_mb = 256
  source_repository {
    url = "https://source.developers.google.com/projects/test-project-miguel/repos/${var.repo_name}/moveable-aliases/main/paths/${var.repo_path}"
  }
  entry_point                  = "pull_requests_summary"
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 200

  environment_variables = {
    EMAIL_FROM = var.email_from
    EMAIL_TO   = var.email_to
  }

  secret_environment_variables {
    key     = "GITHUB_TOKEN"
    secret  = "github-token"
    version = 1
  }

  timeouts {
    create = "150s"
    update = "150s"
    delete = "150s"
  }
  max_instances = 1 # Set the maximum number of instances

}

resource "google_cloudfunctions_function_iam_member" "public_invoker" {
  project        = google_cloudfunctions_function.pull_request_summary.project
  region         = google_cloudfunctions_function.pull_request_summary.region
  cloud_function = google_cloudfunctions_function.pull_request_summary.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

output "https_trigger_url" {
  value = google_cloudfunctions_function.pull_request_summary.https_trigger_url
}
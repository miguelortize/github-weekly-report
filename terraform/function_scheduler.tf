resource "google_cloudbuild_trigger" "cs_repo_trigger" {
  name        = "cloud-function-trigger"
  description = "Trigger for changes in Cloud Source Repository"
  project     = var.project # Ensure you have defined your project ID in your variables or directly insert it here.

  # Define the source that the trigger should listen to
  trigger_template {
    project_id  = var.project
    repo_name   = var.repo_name
    branch_name = "main" # Specify the branch to build from
  }

  # Define the build configuration (can be inline or from a file)
  filename = "cloudbuild.yaml"

  # Optionally define included and ignored files to refine what changes should trigger the build
  included_files = [
    "${var.repo_path}/**/*"
  ]
  ignored_files = [
    "**/*.md"
  ]
}

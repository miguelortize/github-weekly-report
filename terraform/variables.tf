variable "project" {
  type        = string
  description = "The Google Cloud project ID."
  default     = "test-project-miguel"
}

variable "region" {
  type        = string
  description = "The region where the cloud resources will be deployed."
  default     = "us-central1"
}

variable "cloud_function_name" {
  type        = string
  description = "The name of the Google Cloud Function."
  default     = "pull-request-summary"
}

variable "email_from" {
  type        = string
  description = "The email address from which notifications are sent."
  default     = "notifications@example.com"
}

variable "email_to" {
  type        = string
  description = "The email address to which notifications are sent."
  default     = "developer@example.com"
}

variable "service_account" {
  type        = string
  description = "The email of the service account used by the Cloud Function."
  default     = "test-project-miguel@appspot.gserviceaccount.com"
}

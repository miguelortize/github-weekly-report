variable "project" {
  type        = string
  description = "The Google Cloud project ID."
}

variable "region" {
  type        = string
  description = "The region where the cloud resources will be deployed."
}

variable "cloud_function_name" {
  type        = string
  description = "The name of the Google Cloud Function."
}

variable "email_from" {
  type        = string
  description = "The email address from which notifications are sent."
}

variable "email_to" {
  type        = string
  description = "The email address to which notifications are sent."
}

variable "service_account" {
  type        = string
  description = "The email of the service account used by the Cloud Function."
}

variable "repo_name" {
  type        = string
  description = "The name of the Cloud Source Repository."
}

variable "repo_path" {
  type        = string
  description = "The path to the source code in the Cloud Source Repository."
}
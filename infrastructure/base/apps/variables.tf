variable "namespace" {
  description = "Kubernetes namespace for flux"
  type        = string
}

variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "repository_name" {
  type        = string
  description = "github repository name"
}

variable "github_flux_user_name" {
  type        = string
  description = "github user for flux"
}

variable "github_flux_user_password" {
  type        = string
  description = "github user password for flux"
  sensitive   = true
}

variable "branch" {
  type        = string
  description = "branch name"
}

variable "apps_path" {
  type        = string
  description = "Path to apps overlay"
}

variable "apps_namespace" {
  type        = string
  description = "Kubernetes namespace for apps"
}

variable "github_repository_interval" {
  type        = string
  description = "Interval to fetch git repository"
}

variable "kustomization_interval" {
  type        = string
  description = "Interval to fetch kustomization"
}

locals {
  repo_url = "https://github.com/${var.github_owner}/${var.repository_name}.git"
}
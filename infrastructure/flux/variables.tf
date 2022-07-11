variable "namespace" {
  description = "Kubernetes namespace for flux"
  type        = string
}

variable "github_owner" {
  type        = string
  description = "github owner"
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

variable "repository_name" {
  type        = string
  description = "github repository name"
}

variable "repository_visibility" {
  type        = string
  description = "How visible is the github repo"
}

variable "branch" {
  type        = string
  description = "branch name"
}

variable "target_path" {
  type        = string
  description = "flux sync target path"
}

variable "apps_path" {
  type        = string
  description = "Path to apps overlay"
}

locals {
  repo_url_ssh   = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
  repo_url_https = "https://github.com/${var.github_owner}/${var.repository_name}.git"
}
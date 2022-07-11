variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
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

variable "apps_path" {
  type        = string
  description = "Path to apps overlay"
}

locals {
  config_path = "${path.module}/kubeconfig.config"
}

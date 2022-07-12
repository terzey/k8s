variable "namespace" {
  description = "Kubernetes namespace for flux"
  type        = string
}

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

variable "branch" {
  type        = string
  description = "branch name"
}

variable "target_path" {
  type        = string
  description = "flux sync target path"
}

locals {
  repo_url    = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
  config_path = "${path.module}/kubeconfig.config"
}

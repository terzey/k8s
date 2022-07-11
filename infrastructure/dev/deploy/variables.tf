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

variable "deploy_apps" {
  type        = bool
  description = "deploy apps GitRepository and Kustomization"
}

locals {
  config_path = "${path.module}/kubeconfig.config"
  namespace   = "flux-system"
  branch      = "dev"
}

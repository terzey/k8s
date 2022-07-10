variable "kubernetes_cluster_name" {
  description = "The name of kubernetes cluster"
  type        = string
}

variable "flux_namespace" {
  description = "Kubernetes namespace for flux"
  type        = string
}

variable "kubernetes_kubeconfig_path" {
  description = "Path to kubectl kubeconfig"
  type        = string
}

variable "flux_sync_github_owner" {
  type        = string
  description = "github owner"
}

variable "flux_sync_github_token" {
  type        = string
  description = "github token"
  sensitive   = true
}

variable "flux_sync_repository_name" {
  type        = string
  description = "github repository name"
}

variable "flux_sync_repository_visibility" {
  type        = string
  default     = "private"
  description = "How visible is the github repo"
}

variable "flux_sync_branch" {
  type        = string
  default     = "main"
  description = "branch name"
}

variable "flux_sync_target_path" {
  type        = string
  description = "flux sync target path"
}

locals {
  kubernetes_context = "kind-${var.kubernetes_cluster_name}"
}

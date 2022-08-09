variable "cluster_name" {
  description = "The name of kubernetes cluster"
  type        = string
}

variable "cluster_type" {
  description = "Kubernetes cluster type: kind or minikube"
  type        = string
}

locals {
  use_kind     = var.cluster_type == "kind" ? true : false
  use_minikube = var.cluster_type == "minikube" ? true : false
}
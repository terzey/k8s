terraform {
  required_version = ">=  0.13"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.0.13"
    }
  }
  backend "s3" {
    bucket  = "terraform-state-terzey"
    key     = "github.com/terzey/k8s/kubernetes/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

provider "kind" {}

resource "kind_cluster" "this" {
  count          = local.use_kind ? 1 : 0
  name           = var.cluster_name
  wait_for_ready = true
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }
}

resource "null_resource" "minikube_cluster" {
  count = local.use_minikube ? 1 : 0
  provisioner "local-exec" {
    when    = create
    command = "minikube start"
  }
}

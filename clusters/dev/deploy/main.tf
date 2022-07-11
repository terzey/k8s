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
    key     = "github.com/terzey/k9s/clusters/dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

provider "kind" {}


resource "kind_cluster" "this" {
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
  }
}

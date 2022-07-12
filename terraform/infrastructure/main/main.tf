terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.2.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-state-terzey"
    key     = "github.com/terzey/k9s/infrastructure/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

data "terraform_remote_state" "cluster" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "terraform-state-terzey"
    key    = "github.com/terzey/k9s/kubernetes/terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content  = data.terraform_remote_state.cluster.outputs.kubeconfig
  filename = local.config_path
}

locals {
  config_path = "${path.module}/kubeconfig.config"
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = data.terraform_remote_state.cluster.outputs.context
}

provider "kubectl" {}

provider "http" {}

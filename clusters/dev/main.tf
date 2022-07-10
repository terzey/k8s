terraform {

  required_version = ">=  0.13"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.0.13"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.15.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }
  }

  backend "s3" {
    bucket  = "terraform-state-terzey"
    key     = "github.com/terzey/k9s/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

provider "kind" {}

provider "flux" {}

provider "kubernetes" {
  config_path    = var.kubernetes_kubeconfig_path
  config_context = local.kubernetes_context
}

provider "kubectl" {}

provider "github" {
  owner = var.flux_sync_github_owner
  token = var.flux_sync_github_token
}

module "kubernetes_cluster" {
  source       = "../base/kind"
  cluster_name = var.kubernetes_cluster_name
}

module "flux" {
  source                = "../../infrastructure/flux"
  namespace             = var.flux_namespace
  github_owner          = var.flux_sync_github_owner
  github_token          = var.flux_sync_github_token
  target_path           = var.flux_sync_target_path
  branch                = var.flux_sync_branch
  repository_name       = var.flux_sync_repository_name
  repository_visibility = var.flux_sync_repository_visibility
}

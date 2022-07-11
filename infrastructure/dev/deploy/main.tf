terraform {
  required_providers {
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
    key     = "github.com/terzey/k9s/infrastructure/dev/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

data "terraform_remote_state" "cluster" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "terraform-state-terzey"
    key    = "github.com/terzey/k9s/clusters/dev/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "flux" {}

resource "local_sensitive_file" "kubeconfig" {
  content  = data.terraform_remote_state.cluster.outputs.kubeconfig
  filename = local.config_path
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = data.terraform_remote_state.cluster.outputs.context
}

provider "kubectl" {}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}

module "flux" {
  source                    = "../../flux"
  namespace                 = "flux-system"
  branch                    = "dev"
  github_owner              = var.github_owner
  repository_name           = var.repository_name
  repository_visibility     = var.repository_visibility
  target_path               = "clusters/dev"
  github_flux_user_name     = var.github_owner
  github_flux_user_password = var.github_token
  apps_path                 = var.apps_path
}

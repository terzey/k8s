resource "kubernetes_secret" "flux_github_token" {
  metadata {
    name      = "flux-github-token"
    namespace = var.namespace
  }
  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = local.known_hosts
    username       = var.github_flux_user_name
    password       = var.github_flux_user_password
  }
}

resource "kubernetes_manifest" "flux_git_repository" {
  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1beta2"
    kind       = "GitRepository"
    metadata = {
      name      = "apps"
      namespace = var.namespace
    }
    spec = {
      interval = "5m"
      #url      = local.repo_url_ssh
      url = local.repo_url_https
      ref = {
        branch = var.branch
      }
      secretRef = {
        name = "flux-github-token"
      }
    }
  }
}

resource "kubernetes_manifest" "flux_kustomization" {
  manifest = {
    apiVersion = "kustomize.toolkit.fluxcd.io/v1beta2"
    kind       = "Kustomization"
    metadata = {
      name      = "apps"
      namespace = var.namespace
    }
    spec = {
      interval        = "10m"
      targetNamespace = "default"
      sourceRef = {
        kind = "GitRepository"
        name = "apps"
      }
      path  = var.apps_path
      prune = true
    }
  }
}
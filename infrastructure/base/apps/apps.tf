resource "kubernetes_namespace" "apps" {
  metadata {
    name = var.apps_namespace
  }
}
resource "kubernetes_secret" "flux_github_token" {
  metadata {
    name      = "flux-github-token"
    namespace = var.namespace
  }
  data = {
    username = var.github_flux_user_name
    password = var.github_flux_user_password
  }
}

resource "kubernetes_manifest" "flux_github_repository" {
  depends_on = [kubernetes_secret.flux_github_token]
  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1beta2"
    kind       = "GitRepository"
    metadata = {
      name      = "apps"
      namespace = var.namespace
    }
    spec = {
      interval = var.github_repository_interval
      url      = local.repo_url
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
  depends_on = [kubernetes_manifest.flux_github_repository, kubernetes_namespace.apps]
  manifest = {
    apiVersion = "kustomize.toolkit.fluxcd.io/v1beta2"
    kind       = "Kustomization"
    metadata = {
      name      = "apps"
      namespace = var.namespace
    }
    spec = {
      interval        = var.kustomization_interval
      targetNamespace = var.apps_namespace
      sourceRef = {
        kind = "GitRepository"
        name = "apps"
      }
      path  = var.apps_path
      prune = true
    }
  }
}

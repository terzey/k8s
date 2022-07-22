resource "kubernetes_namespace" "this" {
  for_each = var.namespaces
  metadata {
    name = each.value
  }
}

resource "kubernetes_secret" "regcred" {
  depends_on = [kubernetes_namespace.this]
  for_each   = var.namespaces
  metadata {
    name      = "regcred"
    namespace = each.value
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.registry_password
          "email"    = var.registry_email
          "auth"     = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }
}
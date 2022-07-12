data "http" "dashboard" {
  url = "https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml"
}

data "kubectl_file_documents" "dashboard" {
  content = data.http.dashboard.body
}

resource "kubectl_manifest" "dashboard" {
  for_each  = toset([for document in data.kubectl_file_documents.dashboard.documents : document])
  yaml_body = each.value
}

data "kubectl_path_documents" "admin_user" {
  pattern = "./templates/kubernetes-dashboard/*.yaml"
}

resource "kubectl_manifest" "admin_user" {
  depends_on = [kubectl_manifest.dashboard]
  for_each   = toset([for document in data.kubectl_path_documents.admin_user.documents : document])
  yaml_body  = each.value
}

locals {
  config         = local.use_kind ? kind_cluster.this[0].kubeconfig : file("~/.kube/config")
  parsedConfig   = yamldecode(local.config)
  currentContext = local.use_kind ? local.parsedConfig["current-context"] : "minikube"
  cluster        = [for i in local.parsedConfig.clusters : i.cluster if i.name == local.currentContext]
  endpoint       = local.use_kind ? kind_cluster.this[0].endpoint : local.cluster[0].server
}

output "context" {
  value = local.currentContext
}

output "endpoint" {
  value = local.endpoint
}

output "kubeconfig" {
  value = local.config
}
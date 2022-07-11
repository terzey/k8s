output "context" {
  value = yamldecode(kind_cluster.this.kubeconfig)["current-context"]
}

output "endpoint" {
  value = kind_cluster.this.endpoint
}

output "kubeconfig" {
  value = kind_cluster.this.kubeconfig
}
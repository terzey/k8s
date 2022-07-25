resource "null_resource" "helm_repository" {
  for_each   = var.helm_repositories
  depends_on = [module.s3_bucket]
  provisioner "local-exec" {
    when    = create
    command = <<EOF
      helm s3 init "s3://${module.s3_bucket.s3_bucket_id}/${each.value}/charts"
      helm repo add "${each.value}-${var.profile}" "s3://${module.s3_bucket.s3_bucket_id}/${each.value}/charts"
      helm s3 reindex --relative "${each.value}-${var.profile}"
      EOF
  }
}

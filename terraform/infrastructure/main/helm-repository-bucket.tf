module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.helm_repository_bucket_name
}
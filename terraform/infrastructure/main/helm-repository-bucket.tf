module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.helm_repository_bucket_name
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = module.s3_bucket.s3_bucket_id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket_policy" "public" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*"
    ]
  }
}
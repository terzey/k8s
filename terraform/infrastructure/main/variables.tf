variable "helm_repository_bucket_name" {
  type        = string
  description = "Name for s3 bucket for helm repositories"
}

variable "namespaces" {
  type        = set(string)
  description = "List of kubernetes namespaces to be created"
  default     = ["app"]
}
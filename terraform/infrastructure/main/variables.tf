variable "helm_repository_bucket_name" {
  type        = string
  description = "Name for s3 bucket for helm repositories"
}

variable "namespaces" {
  type        = set(string)
  description = "List of kubernetes namespaces to be created"
  default     = ["app"]
}

variable "registry_server" {
  type        = string
  description = "Docker registry server"
}

variable "registry_username" {
  type        = string
  description = "Docker registry server user name"
}

variable "registry_email" {
  type        = string
  description = "Docker registry server user email"
}

variable "registry_password" {
  type        = string
  description = "Docker registry server user password"
  sensitive   = true
}

variable "helm_repositories" {
  type        = set(string)
  description = "List of helm repositories to be created"
  default     = ["web-svc"]
}

variable "profile" {
  type        = string
  description = "One of: [dev, stage, prod]"
}
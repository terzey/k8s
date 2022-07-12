#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/flux-bootstrap/main
terraform init
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"
terraform plan -out=flux-bootstrap.tfplan -lock=true -var-file=../dev/terraform.tfvars \
  -target=local_sensitive_file.kubeconfig
terraform apply -target=local_sensitive_file.kubeconfig flux-bootstrap.tfplan
terraform state rm github_repository.main || echo "github repository is already deleted, skipping"
terraform state rm local_sensitive_file.kubeconfig || echo "kubeconfig is already deleted, skipping"
terraform destroy -lock=true -auto-approve -var-file=../dev/terraform.tfvars

#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./infrastructure/dev/deploy
terraform init
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"
terraform plan -out=infrastructure.tfplan -lock=true -target=local_sensitive_file.kubeconfig
terraform apply -target=local_sensitive_file.kubeconfig infrastructure.tfplan
terraform state rm module.flux.github_repository.main || echo "github repository is already deleted, skipping"
terraform state rm local_sensitive_file.kubeconfig || echo "kubeconfig is already deleted, skipping"
terraform destroy -lock=true -auto-approve

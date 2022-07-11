#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

DIR="$(pwd)"

cd "${DIR}"/infrastructure/flux
terraform fmt

cd "${DIR}"/infrastructure/dev/deploy
terraform init
terraform fmt
terraform validate
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"

terraform import module.flux.github_repository.main "${REPOSITORY_NAME}" || echo "Failed to import repository ${REPOSITORY_NAME}, skipping..."

terraform plan -out=infrastructure.tfplan -lock=true -target=local_sensitive_file.kubeconfig -var-file=./terraform.tfvars
terraform apply -target=local_sensitive_file.kubeconfig infrastructure.tfplan

terraform plan -out=infrastructure.tfplan -lock=true -var-file=./terraform.tfvars
terraform apply infrastructure.tfplan
terraform taint local_sensitive_file.kubeconfig

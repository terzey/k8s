#!/usr/bin/env bash
set -ex

. ./bin/profile.sh

export TF_VAR_flux_sync_github_token="${FLUX_SYNC_GITHUB_TOKEN}"
REPOSITORY_NAME="$(basename "$(git rev-parse --show-toplevel)")"

cd ./clusters/dev
terraform init
terraform fmt
terraform validate
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"
terraform import module.flux.github_repository.main "${REPOSITORY_NAME}" || echo "Failed to import repository '${REPOSITORY_NAME}'. Skipping..."
terraform plan -out=cluster.tfplan -lock=true -var-file=./terraform.tfvars
terraform apply cluster.tfplan

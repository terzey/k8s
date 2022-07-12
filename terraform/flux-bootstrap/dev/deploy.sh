#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/flux-bootstrap/main
terraform init
terraform fmt
terraform validate
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"


# Extract and save kubeconfig file
terraform plan -out=flux-bootstrap.tfplan -lock=true -target=local_sensitive_file.kubeconfig -var-file=../dev/terraform.tfvars
terraform apply -target=local_sensitive_file.kubeconfig flux-bootstrap.tfplan

# Import existing repository
IMPORT_MESSAGE=$(terraform import -var-file=../dev/terraform.tfvars github_repository.main "${REPOSITORY_NAME}" || true)
if [[ "${IMPORT_MESSAGE}" != *"Import prepared"* ]]; then
  echo "Failed to import repository ${REPOSITORY_NAME}"
  exit 1
fi

# Apply changes
terraform plan -out=flux-bootstrap.tfplan -lock=true -var-file=../dev/terraform.tfvars
terraform apply flux-bootstrap.tfplan
terraform taint local_sensitive_file.kubeconfig

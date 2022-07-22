#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/flux-bootstrap/main
terraform init
terraform fmt
terraform validate
create_or_select_tf_namespace "${WORKSPACE}"

# Extract and save kubeconfig file
update_tf_resource local_sensitive_file.kubeconfig -var-file=../dev/terraform.tfvars
# Import existing repository
import_tf_resource github_repository.main "${REPOSITORY_NAME}" -var-file=../dev/terraform.tfvars
# Apply changes
terraform plan -out=flux-bootstrap.tfplan -lock=true -var-file=../dev/terraform.tfvars
terraform apply flux-bootstrap.tfplan
# taint kubeconfig to force reload it from kubernetes state
terraform taint local_sensitive_file.kubeconfig

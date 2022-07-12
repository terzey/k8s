#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/infrastructure/main
terraform init
create_or_select_tf_namespace "${WORKSPACE}"
update_tf_resource local_sensitive_file.kubeconfig ../dev/terraform.tfvars
terraform state rm local_sensitive_file.kubeconfig || echo "kubeconfig is already deleted, skipping"
terraform destroy -lock=true -auto-approve -var-file=../dev/terraform.tfvars

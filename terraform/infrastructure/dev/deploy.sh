#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/infrastructure/main
terraform init
terraform fmt
terraform validate
create_or_select_tf_namespace "${WORKSPACE}"

update_tf_resource local_sensitive_file.kubeconfig -var-file=../dev/terraform.tfvars
terraform plan -out=infrastructure.tfplan -lock=true -var-file=../dev/terraform.tfvars
terraform apply infrastructure.tfplan
# taint kubeconfig to force reload it from kubernetes state
terraform taint local_sensitive_file.kubeconfig

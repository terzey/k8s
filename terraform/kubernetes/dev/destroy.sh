#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/kubernetes/main
terraform init
create_or_select_tf_namespace "${WORKSPACE}"
terraform destroy -lock=true -var-file=../dev/terraform.tfvars -auto-approve

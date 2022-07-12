#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./terraform/kubernetes/main
terraform init
terraform fmt
terraform validate
create_or_select_tf_namespace "${WORKSPACE}"
terraform plan -out=kubernetes.tfplan -lock=true -var-file=../dev/terraform.tfvars
terraform apply kubernetes.tfplan

cat <<EOF
|------------------------------------------------
| Context:             $(terraform output context)
| Endpoint:            $(terraform output endpoint)
|------------------------------------------------
EOF
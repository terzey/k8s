#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./clusters/dev/deploy
terraform init
terraform fmt
terraform validate
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"
terraform plan -out=cluster.tfplan -lock=true -var-file=./terraform.tfvars
terraform apply cluster.tfplan

cat <<EOF
|------------------------------------------------
| Context:             $(terraform output context)
| Endpoint:            $(terraform output endpoint)
|------------------------------------------------
EOF
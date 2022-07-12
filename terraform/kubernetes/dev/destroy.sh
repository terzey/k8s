#!/usr/bin/env bash
set -ex

. ./bin/profile-dev.sh

cd ./clusters/dev/deploy
terraform init
terraform workspace new "${WORKSPACE}" || terraform workspace select "${WORKSPACE}"
terraform destroy -lock=true -var-file=../dev/terraform.tfvars -auto-approve
